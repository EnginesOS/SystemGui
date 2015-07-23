class ServiceConfigurationsController < ApplicationController

  before_action :authenticate_user!
  
  def show
    @service = Service.where(container_name: params[:service_name]).new
  end

  def edit
    @service = Service.where(container_name: params[:service_name]).new
    @service_configuration = @service.build_service_configuration_for params[:configurator_name]
  end

  def update
    @service_configuration = ServiceConfiguration.new(service_configuration_params)
    if @service_configuration.persist!
      redirect_to service_configuration_path(service_name: params[:service_name]), notice: "Successfully updated configuration for #{@service_configuration.label}."
    else
      render :edit
    end
  end
 
private
 
  def service_configuration_params
    params.require(:service_configuration).permit!
  end
  
end


  