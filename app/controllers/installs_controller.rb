class InstallsController < ApplicationController

  include ActionController::Live


  before_action :authenticate_user!

  def installer
    @galleries = Gallery.all
  end

  def new
    @software = Install.new_software_from_gallery(new_software_from_gallery_params)
    if @software.nil?
      flash[:alert] = "Unable to load blueprint."
      redirect_to installer_path
    else
      render :new
    end
  end

  def create
    @software = Install.new_software_for_create(new_software_install_params)
    if @software.save
      create_engine_build
    else
      render :new
    end
  end

  def create_engine_build
    engine_installation_params = Install.engine_build_params(@software)
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
    response.headers['Content-Type'] = 'text/event-stream'
    send_event :installation_progress, "Starting build...\n"
    File.open('/home/engines/deployment/deployed/build.out') do |f|
      f.extend(File::Tail)
      f.interval = 10
      f.backward(10000)
      f.tail do |line|
        # p line
        send_event :installation_progress, line
        break if line.start_with?("Build Finished")
      end
     end
    
   
    
    # if @last_line.start_with?("Applying Volume settings and Log Permissions") 
      # flash[:notice] = "Software installation was successful."
    # elsif @last_line.start_with?("ERROR")
      # flash[:alert] = "Software installation was not successful"
    # else
      # flash[:alert] = "Unexpected response from software installation process"
    # end

    # send_event "All done. Redirect page..."

    EnginesInstaller.installation_report_lines(params[:engine_name]).each do |line|
      # p line
      send_event :installation_report, line
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

  def send_event(event, data='a')
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

  # def set_software
  #   @software = Software.find params[:id]
  # end

end
