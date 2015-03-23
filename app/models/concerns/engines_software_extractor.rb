module EnginesSoftwareExtractor

  def blueprint_software_details(engine_name)
    blueprint = blueprint(engine_name)
    if blueprint.kind_of?(EnginesOSapiResult)
      return blueprint
    else
      blueprint['software']
    end
  end

  def blueprint_software_name(engine_name)
    blueprint_software_details = blueprint_software_details(engine_name)
    if blueprint_software_details.kind_of?(EnginesOSapiResult)
      return blueprint_software_details
    else
      blueprint_software_details['name']
    end
  end

  def software_variables(engine_name)
    blueprint_software_details(engine_name)['variables']
  end

  def volumes(engine_name)
    volumes_hash(engine_name).values
  end

  def persistant_services(engine_name)
    engines_api.get_engine_persistant_services({engine_name: engine_name})
  end

  def consumers(engine_name)
    consumers_hash(engine_name).values
  end

  def backup_tasks(engine_name)
    EnginesBackupTask.all #.select { |backup_task| backup_task.present? }
  end

  def attached_services(engine_name)
    engines_api.list_attached_services_for('ManagedEngine', engine_name)
  end

  def attached_service_types(engine_name)
    attached_services(engine_name).keys
  end

  def attached_subservices(service_class, service_name)
    engines_api.list_attached_services_for(service_class, service_name)
  end

  def available_services_hash(engine_name)
    engines_api.list_avail_services_for(EnginesSoftware.engines_software(engine_name))
  end

  def available_services(engine_name)
    available_services_hash(engine_name)[:services]
  end

  def available_subservices(engine_name, service_type)
    available_services_hash(engine_name)[:subservices][service_type.to_sym]
  end

end