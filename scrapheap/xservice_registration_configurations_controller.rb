class ServiceRegistrationConfigurationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_service_registration_configuration

  def edit
    @service_registration_configuration.build
  end

  def update
    @service_registration_configuration.update(service_registration_configuration_params)
    if @service_registration_configuration.valid?
      result = @service_registration_configuration.persist!
      if result.was_success
        redirect_to control_panel_path, notice: "Successfully updated application variables for #{@service_registration_configuration.application_name}."
      else
        redirect_to control_panel_path, error: "Unable to update application variables for #{@service_registration_configuration.application_name}. #{result.result_mesg}"[0..1000]
      end 
    else
      render :edit
    end
  end

private

  def set_service_registration_configuration
    @service_registration_configuration = ServiceRegistrationConfiguration.new application_name: application_name
  end
      
  def application_name
    params[:id]
  end

  def service_registration_configuration_params
    params.require(:service_registration_configuration).permit!
  end
  
end
