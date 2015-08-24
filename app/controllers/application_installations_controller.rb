class ApplicationInstallationsController < ApplicationController

  include ActionController::Live
  include Engines::Api

  before_action :authenticate_user!

  def new
    @application_installation = ApplicationInstallation.new(application_installation_params).load_new
    redirect_to installer_path,
      alert: "Unable to install #{application_installation_params[:software_title]}. Can't load from repository #{params[:repository_url]}." if @application_installation.blueprint == false
  end

  def create
    @application_installation = ApplicationInstallation.new(application_installation_params)
    # render text: @application_installation.engine_build_params
    if @application_installation.install
      redirect_to preparing_installation_application_installation_path(application_name: application_installation_params["application_attributes"]["container_name"]) #set_installing_params_application_installation_path(@application_installation.installing_params)
    else
      render :new
    end
  end

  def preparing_installation
    @application_name = params[:application_name]
  end

  def preparing_installation_progress

p :installing?    
p System.installing?   
p engines_api.build_status
 
    if !System.installing?
      render text: "busy"
    else
      render text: "done"
    end
  end

  def installing
    # render text: System.installing_params
    if System.installing?
      @application_installation_progress = ApplicationInstallationProgress.new(System.installing_params)
    else
      redirect_to control_panel_path, alert: "Installation not in progress."
    end
  end

  def progress
    # render text: params
    @application_installation_progress = ApplicationInstallationProgress.new(application_name: params[:application_name])
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
          System.disable_installing_flag
          break
        end
        previous_line = line
      end
    end
    @application_installation_progress.installation_report_lines.each do |line|
      send_event :installation_report, line
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

  # def software_params
    # params.permit(:repository_url, :gallery_icon_url, :title, :application_name, :host_name, :domain_name)
  # end

  def application_installation_params
    params.require(:application_installation).permit!
  end


end
