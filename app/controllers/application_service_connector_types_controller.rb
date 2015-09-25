class ApplicationServiceConnectorTypesController < ApplicationController

  before_action :set_application_service_connector

  def new
    if @application_service_connector.no_existing_connections?
      redirect_to new_application_service_connector_configuration_path(
          @application_service_connector.connector_configuration_attributes
        )
    else
      @application_service_connector.build_application_service_connector_type(create_type: :new)
    end
  end

  def create
    if @application_service_connector.valid?
      redirect_to new_application_service_connector_configuration_path(
        @application_service_connector.connector_configuration_attributes
      )
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
    params.require(:application_service_connector).permit(:type_path, :publisher_namespace, application_service_connector_type_attributes: [:create_type, :active_service, :orphan_service])
  end

end

  