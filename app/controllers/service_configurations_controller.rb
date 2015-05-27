class ServiceConfigurationsController < ApplicationController

  before_action :authenticate_user!
  
  def show
    @service = Service.where(container_name: params[:service_name]).new
  end

  def edit
    @service_configuration = ServiceConfiguration.new(service_name: params[:service_name], configurator_name: params[:configurator_name]).load
  end

  def update
    @service_configuration = ServiceConfiguration.new(service_name: params[:service_name], configurator_name: params[:configurator_name])
    if @service_configuration.update(service_configuration_params)
      redirect_to service_configuration_path(service_name: params[:service_name]), notice: "Successfully updated configuration for #{params[:configurator_name]}."
    else
      render :edit
    end
  end
 
private
 
  def service_configuration_params
    params.require(:service_configuration).permit!
  end

end


  