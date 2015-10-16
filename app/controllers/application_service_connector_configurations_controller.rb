class ApplicationServiceConnectorConfigurationsController < ApplicationController

  before_action :set_application_service_connector

  def new
    @application_service_connector.load_application_service_connector_configuration_variables
  end
  
  def create
    # render text: params
    if @application_service_connector.connect
      redirect_to application_services_properties_path(application_name: @application_service_connector.application.container_name), 
        notice: "Successfully connected #{@application_service_connector.title} to #{@application_service_connector.application.container_name}."
    else
      render :new
    end
  end

private

  def set_application_service_connector
    @application_service_connector = application.application_service_connectors.build(application_service_connector_params)
  end

  def application
    Application.find_by(container_name: application_name)
  end

  def application_name
    params[:application_name]
  end

  def application_service_connector_params
    params.require(:application_service_connector).permit! #(:type_path, :publisher_namespace, application_service_connector_configuration_attributes: [:create_type, :existing_service, variables_attributes:])
  end

end

  
