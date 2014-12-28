class SoftwaresController < ApplicationController

  include EnginesSoftwaresActions

  before_action :authenticate_user!

  before_action :set_softwares, only: :index
  before_action :set_software,
    only: [
      :edit_display_properties,
      :edit_runtime_properties,
      :edit_network_properties,
      # :show_about_properties,
      :update_display_properties,
      :update_network_properties,
      :update_runtime_properties]
  before_action :load_software_network_properties, only: :edit_network_properties
  before_action :load_software_runtime_properties, only: :edit_runtime_properties
  
  def destroy_all_records
    Software.delete_all
    redirect_to softwares_path 
  end

  def new
    EnginesMaintenance.db_maintenance
    @software = Software.new_from_repository gallery_url: software_params["gallery_url"], software_id: software_params["software_id"]
  end

  def create
    if software_params["terms_and_conditions_accepted"] == "0"
      redirect_to new_software_path(software: software_params), alert: "You must accept the license terms and conditions to install this software."
    elsif EnginesInstaller.engine_name_not_unique?(software_params[:engine_name])
      redirect_to new_software_path(software: software_params), alert: "Engine name must be unique."
    elsif EnginesInstaller.host_name_not_unique?(software_params[:host_name])
      redirect_to new_software_path(software: software_params), alert: "Host name must be unique."
    else
      if @software = Software.create(software_params)
        if @software.icon.exists? == false
          @software.attach_default_icon
          @software.save
        end
        redirect_to install_path(id: software_params[:engine_name], software: software_params)
      else
        redirect_to installer_path, alert: "Unable to initiate application installation for #{@software.engine_name}. Failed to save display properties to database."
      end
    end


  end

  def install
    install_response = EnginesInstaller.install_engines_software software_params
    if install_response.instance_of?(ManagedEngine)
      redirect_to control_panel_path, notice: "Application installation was successful for #{params[:id]}."
    elsif install_response.instance_of?(EnginesOSapiResult)
      redirect_to installer_path, alert: "Application installation was not successful for #{params[:id]}. " + install_response.result_mesg[0..250]
    else
      render text: "Unexpected response from software installation process for #{params[:id]}."
    end
  end

  def update_display_properties
    if @software.update_display_properties(software_params)
      redirect_to control_panel_path, notice: "Display properties were successfully updated for #{@software.engine_name}."
    else
      redirect_to edit_display_properties_software_path(software: software_params), alert: "Display properties were not updated for #{@software.engine_name}."
    end
  end

  def update_network_properties
    if @software.update_network_properties software_params
      redirect_to control_panel_path, notice: "Network properties were successfully updated for #{@software.engine_name}."
    else
      redirect_to edit_network_properties_software_path(software: software_params), alert: "Network properties were not updated for #{@software.engine_name}."
    end
  end

  def update_runtime_properties
    if @software.update_runtime_properties software_params
      redirect_to control_panel_path, notice: "Runtime properties were successfully updated for #{@software.engine_name}."
    else
      render edit_runtime_properties_software_path(software: software_params), alert: "Runtime properties were not updated for #{@software.engine_name}."
    end
  end

  def advanced_detail
    @engine_name = params[:id]
    render partial: "advanced_detail"
  end

private

  def software_params
    @software_params ||= params.require(:software).permit!
  end

  def set_software
    @software = Software.find params[:id]
  end

  def set_softwares
    @softwares = Software.all
  end

  def load_software_network_properties
    @software.load_engines_software_network_parameters
  end

  def load_software_runtime_properties
    @software.load_engines_software_runtime_parameters
  end

end