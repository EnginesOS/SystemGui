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
      {connection_params: existing_connection_params.to_json}
    end
  end

end
