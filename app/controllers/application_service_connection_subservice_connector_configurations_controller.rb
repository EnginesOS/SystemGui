class ApplicationServiceConnectionSubserviceConnectorConfigurationsController < ApplicationController
  
  def new
    @application_service_connection_subservice_connector_configuration =
      ApplicationServiceConnectionSubserviceConnectorConfiguration.
        new.build_new_for(application_service_connection_subservice_connector_configuration_params)
  end

  def create
    @application_service_connection_subservice_connector_configuration =
      ApplicationServiceConnectionSubserviceConnectorConfiguration.
        new.build_create_for(application_service_connection_subservice_connector_configuration_params)
    if @application_service_connection_subservice_connector_configuration.connect
      redirect_to application_services_properties_path(
        application_name: @application_service_connection_subservice_connector_configuration.application_name), 
          notice: 'Successfully connected ' + @application_service_connection_subservice_connector_configuration.label
    else
      render :new
    end
  end

private

  def application_service_connection_subservice_connector_configuration_params
    params.require(:application_service_connection_subservice_connector_configuration).permit!
  end

end
