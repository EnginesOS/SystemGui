class ApplicationInstallationsController < ApplicationController

  include ActionController::Live
  include Engines::Api

  before_action :authenticate_user!

  # def new
    # @application_installation = ApplicationInstallation.new(application_installation_params).load_new
    # redirect_to installer_path,
      # alert: "Unable to install #{application_installation_params[:software_title]}. Can't load from repository #{params[:repository_url]}." \
        # if @application_installation.blueprint == false
  # end
# 
  def preparing_installation
    @application_name = params[:application_name]
  end

  def preparing_installation_progress
    if System.waiting_for_installation
      render text: 'busy'
    else
      render text: 'done'
    end
  end

  def installing
    if System.installing?
      @application_installation_progress = ApplicationInstallationProgress.new(System.installing_params)
    else
      redirect_to control_panel_path, alert: "Not installing."
    end
  end

  def progress
    response.headers['Content-Type'] = 'text/event-stream'
    send_event :installation_progress, "Starting build...\n"
    send_installation_progress
    send_installation_report
  ensure
    send_event :message, 'done'
    response.stream.close
  end

private

  def send_installation_progress
    error = false
    previous_line = ''
    File.open('/home/engines/deployment/deployed/build.out') do |f|
      f.extend(File::Tail)
      f.interval = 10
      f.backward(10000)
      f.tail do |line|
        send_event :installation_progress, line
        if line.start_with?('Build Finished')
          error = true if previous_line.start_with?('ERROR')
          break
        end
        previous_line = line
      end
    end
  end

  def send_installation_report
    ApplicationInstallationProgress.new(application_name: params[:application_name]).installation_report_lines.each do |line|
      send_event :installation_report, line
    end
  end

  def send_event(event, data='')
       response.stream.write "event: #{event}\n"
       response.stream.write "data: #{data}\n\n"
  end

  def application_installation_params
    params.require(:application_installation).permit!
  end

end
