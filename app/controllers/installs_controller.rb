class InstallsController < ApplicationController

  before_action :authenticate_user!

  def installer
    @galleries = Gallery.all
  end

  def new
    EnginesMaintenance.db_maintenance
    @software = Install.new_software gallery_url: software_install_params["gallery_url"], software_id: software_install_params["software_id"]
  end

  def create
    @software = Software.new(software_install_params)
    create_attach_icon
  end

  def create_attach_icon
    url = @software.install.default_image_url
    if url == "Broken"
      flash[:alert] = "The URL for the icon image is invalid for #{@software.engine_name}. "
    else
      @software.display.icon = EnginesUtilities.icon_from_url url
    end
    create_validate_software
  end

  def create_validate_software
    # @software.update software_install_params
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

  def software_install_params
    params.require(:software).permit!
  end

  def set_software
    @software = Software.find params[:id]
  end

end
