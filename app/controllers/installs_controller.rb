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
    @software = Software.new(new_software_install_params)
    if @software.save
      create_engine_build
    else
      render :new
    end
  end

  def create_engine_build
    engine_installation_params = Install.engine_build_params(@software)
    Thread.new do
      build_response = EnginesInstaller.build_engine(engine_installation_params)
    end
    redirect_to installing_installs_path(engine_installation_params)
  end

  def blueprint
    @blueprint = blueprint_params
    render layout: 'empty_navbar'
  end

  def progress
    response.headers['Content-Type'] = 'text/event-stream'
    filename = '/home/engines/deployment/deployed/build.out'
    File.open(filename) do |file|
      file.extend(File::Tail)
      file.interval = 10
      file.backward(10000)
      file.tail do |line|
        # line = line [1..-2]
        @last_line = line;
        p line
        send_event line
        break if line.start_with?("Applying Volume settings and Log Permissions")
      end
    end
    # if @last_line.start_with?("Applying Volume settings and Log Permissions") 
      # flash[:notice] = "Software installation was successful."
    # elsif @last_line.start_with?("ERROR")
      # flash[:alert] = "Software installation was not successful"
    # else
      # flash[:alert] = "Unexpected response from software installation process"
    # end

  ensure
    send_event "All done. Redirecting page..."
    response.stream.close
  end

private

  def send_event message
       unless message.blank?
            response.stream.write "event: message\n"
            response.stream.write "data: #{message}\n"
       end
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
