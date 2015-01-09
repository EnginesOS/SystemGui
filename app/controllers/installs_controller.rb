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
    if @software.save
      # if @software.icon.exists? == false
      #   @software.attach_default_icon
      #   @software.save
      # end
      redirect_to engine_install_path(software: software_install_params)
    else
      render :new
      # redirect_to installer_path, alert: "Unable to initiate application installation for #{@software.engine_name}. Failed to save display properties to database."
    end
    # end
  end

  def engine_install
    install_response = EnginesInstaller.install_engines_software engine_install_params
    engine_name = engine_install_params[:engine_name]
    if install_response.instance_of?(ManagedEngine)
      redirect_to control_panel_path, notice: "Application installation was successful for #{engine_name}."
    elsif install_response.instance_of?(EnginesOSapiResult)
      redirect_to installer_path, alert: "Application installation was not successful for #{engine_name}. " + install_response.result_mesg[0..1000]
    else
      render text: "Unexpected response from software installation process for #{engine_name}."
    end
  end

private

  def engine_install_params
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
    @software_install_params ||= params.require(:software).permit!
  end

  def set_software
    @software = Software.find params[:id]
  end

end
