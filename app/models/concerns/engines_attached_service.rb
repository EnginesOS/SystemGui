module EnginesAttachedService

  extend EnginesApi
  def self.service_detail_for(type_path, publisher_namespace)
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

  def self.delete_orphaned_service(params)
    engines_api.delete_orphaned_service params
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

  def self.orphaned_services(type_path, publisher_namespace)
    engines_api.get_orphaned_services(type_path: type_path, publisher_namespace: publisher_namespace)
  end

  def self.active_attached_services(type_path, publisher_namespace)
    engines_api.get_active_attached_services(type_path: type_path, publisher_namespace: publisher_namespace)
  end

end