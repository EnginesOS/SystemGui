class InstallsController < ApplicationController

  before_action :authenticate_user!

  def installer
    @galleries = Gallery.all
  end

  def new
    @software = Install.new_software_from_gallery(new_software_from_gallery_params)
  end

  def create
    @software = Software.new(new_software_install_params)
    create_attach_icon
  end

  def create_attach_icon
    url = @software.install.default_image_url

p "::::::::::::"
p "image url " + url.to_s


    file = EnginesUtilities.icon_from_url url
    if file == nil
      flash[:alert] = "The icon image could not be loaded for #{@software.engine_name}. "
    else
      @software.display.icon = file
    end
    create_validate_software
  end

  def create_validate_software
    # @software.update new_software_install_params
    if @software.valid?
      create_engine_build
    else
      render :new
    end
  end

  def create_engine_build
    build_response = EnginesInstaller.build_engine(Install.engine_build_params(@software))
    if build_response.instance_of?(ManagedEngine)
      # @software.
      @software.save
      redirect_to control_panel_path, notice: "Software installation was successful for #{@software.engine_name}."
    elsif build_response.instance_of?(EnginesOSapiResult)
      alert_message = "Software installation was not successful for #{@software.engine_name.to_s}. (" + build_response.result_mesg.to_s[0..1000] + ')'
      if flash[:alert].nil?
        flash[:alert] = alert_message
      else
        flash[:alert] << alert_message
      end
      redirect_to installer_path
    else
      redirect_to installer_path, alert: "Unexpected response from software installation process for #{@software.engine_name}."
    end
  end

private

  def new_software_from_gallery_params
    params.require(:software).permit(:gallery_url, :gallery_software_id)
  end

  def new_software_install_params
    params.require(:software).permit!
  end

  # def set_software
  #   @software = Software.find params[:id]
  # end

end
