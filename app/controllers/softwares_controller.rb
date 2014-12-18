class SoftwaresController < ApplicationController

  include EnginesSoftwaresActions

  before_action :authenticate_user!
  before_action :set_software, only: [
    :create,
    :installing,
    :edit_display_properties,
    :edit_runtime_properties,
    :edit_network_properties,
    # :show_about_properties,
    :update_display_properties,
    :update_network_properties,
    :update_runtime_properties]
  before_action :refresh_software_properties, only: [
    # :edit_display_properties,
    :edit_network_properties,
    # :show_about_properties,
    :edit_runtime_properties]
  before_action :set_softwares, only: :index
  # before_action :refresh_all_softwares_properties, only: :index

  def destroy_all_records
    Software.delete_all
    redirect_to softwares_path 
  end

  def new
    Maintenance.db_maintenance
    @software = Software.new_from_gallery software_params
  end

  def create
    if software_params["terms_and_conditions_accepted"] == "0"
      redirect_to new_software_path(software: software_params), alert: "You must accept the license terms and conditions to install this software."
    elsif Software.engine_name_not_unique(software_params)
      redirect_to new_software_path(software: software_params), alert: "Engine name must be unique."
    elsif Software.host_name_not_unique(software_params)
      redirect_to new_software_path(software: software_params), alert: "Host name must be unique."
    else
      if @software.update(software_params)
        if @software.icon.exists? == false
          @software.attach_icon_using_icon_url_from_gallery
          @software.save
        end
        redirect_to installing_path(id: software_params[:engine_name], software: software_params)
      else
        redirect_to installer_path, alert: "Unable to initiate application installation for #{@software.engine_name}. Failed to save display properties to database."
      end
    end
  end

  def installing
    @software.update(software_params)
    build_response = @software.build_app
    if build_response.instance_of?(ManagedEngine)
      redirect_to control_panel_path, notice: "Application installation was successful for #{@software.engine_name}."
    elsif build_response.instance_of?(EnginesOSapiResult)
      redirect_to installer_path, alert: "Application installation was not successful for #{@software.engine_name}. " + build_response.result_mesg[0..250]
    else
      return render text: 'Unexpected response from build_app.'
    end
  end

  def update_display_properties
    if @software.update_display_properties(software_params)
      redirect_to control_panel_path, notice: "Display properties were successfully updated for #{@software.engine_name}."
    else
      redirect_to edit_display_properties_app_path(software: software_params), alert: "Display properties were not updated for #{@software.engine_name}."
    end
  end

  def update_network_properties
    if @software.update_network_properties software_params
      redirect_to control_panel_path, notice: "Network properties were successfully updated for #{@software.engine_name}."
    else
      redirect_to edit_software_network_properties_path(software: software_params), alert: "Network properties were not updated for #{@software.engine_name}."
    end
  end

  def update_runtime_properties
    if @software.update_runtime_properties software_params
      redirect_to control_panel_path, notice: "Runtime properties were successfully updated for #{@software.engine_name}."
    else
      render edit_software_runtime_properties_path(software: software_params), alert: "Runtime properties were not updated for #{@software.engine_name}."
    end
  end

  def advanced_detail
    @engine_name = params[:id]
    # render text: @engine_name
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

  def refresh_software_properties
    @software.load_properties_from_engine
  end

  # def refresh_all_softwares_properties
  #   @softwares.each(&:load_properties_from_engine)
  # end

end