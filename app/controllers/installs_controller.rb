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
    if @software.valid?
      create_engine_build
    else
      render :new
    end
  end

  def create_engine_build
    build_response = EnginesInstaller.build_engine(Install.engine_build_params(@software))
    if build_response.instance_of?(ManagedEngine)
      @software.save
      flash[:notice] = "Software installation was successful for #{@software.engine_name}."
    elsif build_response.instance_of?(EnginesOSapiResult)
      flash[:alert] = "Software installation was not successful for #{@software.engine_name.to_s}. (" + build_response.result_mesg.to_s[0..1000] + ')'
    else
      flash[:alert] = "Unexpected response from software installation process for #{@software.engine_name}."
    end
    redirect_to installer_path
  end

  def blueprint
    @blueprint = blueprint_params
    render layout: 'empty_navbar'
  end

  def progress
    response.headers['Content-Type'] = 'text/event-stream'
    10.times {
      response.stream.write "hello world\n"
      sleep 1
    }
  ensure
    response.stream.close
  end

private

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
