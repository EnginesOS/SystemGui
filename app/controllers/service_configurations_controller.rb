class ServiceConfigurationsController < ApplicationController

  before_action :authenticate_user!
  # before_action :set_service
  
  def show
    @service = Service.new(container_name: params[:service_name])
  end

  def edit
    # render text: @service.service_configuration_variables_for(params[:configurator_name])
    @service = Service.where(container_name: params[:service_name]).new
    @service_configuration = ServiceConfiguration.new(service_name: params[:service_name])
    @service_configuration.assign_attributes(@service.configurator_params_for(params[:configurator_name])) #, name: params[:name]).load
  end

  def update
    @service_configuration = ServiceConfiguration.new(service_configuration_params)
    # render text: @service_configuration.update_service_configuration_params
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
  
  # def set_service
    # @service = Service.where(container_name: params[:service_name]).new
  # end

end


  