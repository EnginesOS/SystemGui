module EnginesAttachedService

  extend EnginesApi

  def self.service_detail_for(type_path, publisher_namespace)
    
p 'service_detail_for' 
p publisher_namespace
p type_path
 
    engines_api.software_service_definition(
      publisher_namespace: publisher_namespace,
      type_path: type_path)
  end

  def self.attach_service params
    engines_api.attach_service params
  end

  def self.detach_service params
    engines_api.detach_service params
  end

  def self.attach_subservice params
    engines_api.attach_subservice params
  end
  
  def self.detach_subservice params
    engines_api.detach_subservice params
  end

  def self.attached_subservices(service_class, service_name)
    engines_api.list_attached_services_for(service_class, service_name)
  end

  def self.available_services(engine_name)
    engines_api.list_avail_services_for(EnginesSoftware.engines_software(engine_name))
  end

  def self.docker_hub_install_available_services
    # engines_api.list_avail_services_for_type('ManagedEngine')
    engines_api.list_avail_services_for(EnginesSoftware.engines_software('phpmyadmin'))
  end
  
  def self.service_is_persistant(type_path, publisher_namespace)
    true
     # || SoftwareServiceDefinition.is_persistant?(
      # publisher_namespace: publisher_namespace,
      # type_path: type_path)
  end

end