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
      redirect_to installer_path, alert: "Software installation was not successful for #{@software.engine_name}. The URL for the icon image is invalid."
    else
      @software.display.icon = EnginesUtilities.icon_from_url url
      create_validate_software
    end
  end

  def create_validate_software
    if @software.save
      create_engine_build
    else
      render :new
    end
  end

  def create_engine_build
    build_response = EnginesInstaller.build_engine engine_build_params
    if build_response.instance_of?(ManagedEngine)
      redirect_to control_panel_path, notice: "Software installation was successful for #{@software.engine_name}."
    elsif build_response.instance_of?(EnginesOSapiResult)
      redirect_to installer_path, alert: "Software installation was not successful for #{@software.engine_name}. " + build_response.result_mesg[0..1000]
    else
      redirect_to installer_path, alert: "Unexpected response from software installation process for #{@software.engine_name}."
    end
  end

private

  def engine_build_params
    result = {}
    software_install_params.each do |k,v|
      if v.kind_of? Hash
        v.each do |k,v|
          result[k.to_sym] = v
        end
      else
        result[k.to_sym] = v
      end
    end
    result
  end

  def software_install_params
    params.require(:software).permit!
  end

  def set_software
    @software = Software.find params[:id]
  end

end
