class ApplicationNetworkPropertiesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_application_network_properties

  def edit
    @application_network_properties.load
  end

  def update
    if @application_network_properties.update(application_network_properties_params)
        redirect_to control_panel_path, notice: "Successfully updated network properties for #{application_name}."
    else
      render :edit 
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


  