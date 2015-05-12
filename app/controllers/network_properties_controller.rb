class NetworkPropertiesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_network_properties

  def edit
    @network_properties.load
  end

  def update
    if @network_properties.update(network_properties_params)
      # if @network_properties.save
        redirect_to control_panel_path, notice: "Successfully updated network properties for #{application_name}."
      # else
        # redirect_to control_panel_path, alert: "Unable to update network properties for #{application_name}."
      # end
    else
      render :edit
    end
  end

private

  def set_network_properties
    @network_properties = Application.find_by(container_name: application_name).build_network_properties
  end
      
  def application_name
    params[:application_name]
  end

  def network_properties_params
    params.require(:network_properties).permit(:host_name, :domain_name, :http_protocol)
  end

end


  