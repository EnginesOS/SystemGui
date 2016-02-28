class ServiceConfigurationsController < ApplicationController

  def show
    @service = Service.load_by_container_name params[:service_name]
  end

  def edit
    @service = Service.load_by_container_name params[:service_name]
    @service_configuration = @service.build_configuration_for params[:configurator_name]
  end

  def update
    @service = Service.load_by_container_name params[:service_name]
    @service_configuration = ServiceConfiguration.new(service: @service)
    @service_configuration.assign_attributes(service_configuration_params)
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
