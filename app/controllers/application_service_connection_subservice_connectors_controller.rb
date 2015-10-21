class ApplicationServiceConnectionSubserviceConnectorsController < ApplicationController
  
  def new
    @subservice_connector =  ApplicationServiceConnectionSubserviceConnector.new(application_service_connection_params, subservice_params)
  end
  
  # def show
    # @application_services_properties = Application.find_by(container_name: application_name).build_application_services_properties
    # @application_services_properties.build_application_services
  # end

private

  def application_service_connection_params
    params.require(:application_service_connection)
  end

  def subservice_params
    params.require(:subservice)
  end

end
