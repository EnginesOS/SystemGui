class ApplicationInstallationsController < ApplicationController

  include ActionController::Live
  include Engines::Api

  before_action :authenticate_user!

  def new
    @application_installation = ApplicationInstallation.new(software_params).load
  end

  def create
    @application_installation = ApplicationInstallation.new(application_installation_params)
    if @application_installation.install
      redirect_to installing_application_installation_path(@application_installation.installing_params)
    else
      render :new
    end
  end

  def installing
    @application_installation_progress = ApplicationInstallationProgress.new(software_params)
  end

  def progress
    @application_installation_progress = ApplicationInstallationProgress.new(software_params)
    error = false
    previous_line = ''
    response.headers['Content-Type'] = 'text/event-stream'
    send_event :installation_progress, "Starting build...\n"
    File.open('/home/engines/deployment/deployed/build.out') do |f|
      f.extend(File::Tail)
      f.interval = 10
      f.backward(10000)
      f.tail do |line|
        send_event :installation_progress, line
        if line.start_with?("Build Finished")
          error = true if previous_line.start_with?("ERROR")
          break 
        end
        previous_line = line
      end
    end
    unless error
      @application_installation_progress.installation_report_lines.each do |line|
        send_event :installation_report, line
      end
    end
  ensure
    send_event :message, "close"
    response.stream.close
  end

private

  def send_event(event, data='')
       response.stream.write "event: #{event}\n"
       response.stream.write "data: #{data}\n\n"
  end

  def software_params
    params.permit(:gallery_url, :gallery_software_id, :title, :application_name, :host_name, :domain_name)
  end

  def application_installation_params
    params.require(:application_installation).permit!
  end


end
