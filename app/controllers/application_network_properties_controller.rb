class ApplicationNetworkPropertiesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_application_network_properties

  def edit
    @application_network_properties.load
  end

  def update
    @application_network_properties.assign_attributes(application_network_properties_params)
# update_network_properties
    if @application_network_properties.update_engines
      # if @network_properties.save
        redirect_to control_panel_path, notice: "Successfully updated network properties for #{application_name}."
      # else
        # redirect_to control_panel_path, alert: "Unable to update network properties for #{application_name}."
      # end
    else
      render :edit # text: @network_properties.engines_update_params #.engines_api_error #:edit 
    end
  end

private

  def set_application_network_properties
    @application_network_properties = Application.find_by(container_name: application_name).build_application_network_properties
  end
      
  def application_name
    params[:application_name]
  end

  def application_network_properties_params
    params.require(:application_network_properties).permit(:host_name, :domain_name, :http_protocol)
  end

end


  