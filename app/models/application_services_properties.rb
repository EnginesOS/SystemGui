class ApplicationServicesProperties < ActiveRecord::Base

  include Engines::Api

  belongs_to :application
  
   def build_application_services
      application_services = application.application_services.build(existing_connections_params)
      application_services.each do |application_service|
        application_service.existing_connection.build
      end
  end

  def properties_from_system
    @properties ||= (application.services_properties || [])
  end
  
  def existing_connections_params
    properties_from_system.map do |existing_connection_params|
      {
        connection_params: {
          parent_engine: existing_connection_params[:parent_engine],
          type_path: existing_connection_params[:type_path],
          publisher_namespace: existing_connection_params[:publisher_namespace],
          service_handle: existing_connection_params[:service_handle],
          container_type: existing_connection_params[:container_type],
          service_container_name: existing_connection_params[:service_container_name]
        }.to_json
      }
    end
  end

end
