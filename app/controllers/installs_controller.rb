class InstallsController < ApplicationController

  include ActionController::Live


  before_action :authenticate_user!

  def installer
    @galleries = Gallery.all
  end

  def gallery_software
    @gallery = Gallery.find(params[:gallery_id])
    @softwares = @gallery.search_software_titles(params[:search]).sort_by{|b| b["title"] }
    render partial: 'gallery_software'    
  end


  def new
    @software = Install.new_software_from_gallery(new_software_from_gallery_params)
    @attached_services_handler = @software.attached_services_handler
    if @software.nil?
      flash[:alert] = "Unable to load blueprint."
      redirect_to installer_path
    else
      render :new
    end
  end

  def create
    # render text: new_software_install_params
    # render text: params

    @software = Install.new_software_for_create(new_software_install_params)
    @attached_services_handler = @software.attached_services_handler
    @install = @software.install
    if @software.valid?
      create_engine_build
    else
      render :new
    end
  end

  def create_engine_build
    # render text: @software.engine_build_params
    engine_installation_params = @software.engine_build_params
    # render text: (engine_installation_params.to_s + "<br><br>" + new_software_install_params.to_s).html_safe
    build_thread_object_id = Thread.new do
      EnginesInstaller.build_engine(engine_installation_params)
    end.object_id
    engine_installation_params[:build_thread_object_id] = build_thread_object_id
    redirect_to installing_installs_path(engine_installation_params)
  end

  def blueprint
    @blueprint = blueprint_params
    render layout: 'empty_navbar'
  end

  def progress
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
      EnginesInstaller.installation_report_lines(params[:engine_name]).each do |line|
        send_event :installation_report, line
      end
    end
  ensure
    send_event :message, "close"
    response.stream.close
  end

  # def cancel_installation
    # render text: params  
    # # Thread.kill(params[:build_thread_object_id])
  # end

private

  def send_event(event, data='')
       response.stream.write "event: #{event}\n"
       response.stream.write "data: #{data}\n\n"
  end

  def new_software_from_gallery_params
    params.require(:software).permit(:gallery_url, :gallery_software_id)
  end

  def new_software_install_params
    params.require(:software).permit!
  end

  def blueprint_params
    params.require(:blueprint)
  end

end
