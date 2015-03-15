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
    blueprint_environment_variables = blueprint_software_details(engine_name)['environment_variables']
    environments(engine_name).map(&:attributes).each do |environment_variable|
      next if environment_variable.nil?
      blueprint_environment_variable = blueprint_environment_variables.find do |ev|
        next if ev.nil?
        ev["name"].gsub(' ', '_') == environment_variable[:name]
      end
      next if blueprint_environment_variable.nil?
      environment_variable[:label] = blueprint_environment_variable["label"]
      environment_variable[:comment] = blueprint_environment_variable["comment"] 
      environment_variable[:type] = blueprint_environment_variable["type"] 
      environment_variable[:regex_validator] = blueprint_environment_variable["regex_validator"] 
      environment_variable[:mandatory] = blueprint_environment_variable["mandatory"] 
      environment_variable[:collection] = blueprint_environment_variable["collection"] 
      environment_variable[:ask_at_build_time] = blueprint_environment_variable["ask_at_build_time"] 
      environment_variable[:build_time_only] = blueprint_environment_variable["build_time_only"] 
      environment_variable[:immutable] = blueprint_environment_variable["immutable"] 
    end
  end

  def volumes(engine_name)
    volumes_hash(engine_name).values
  end

  def persistant_services(engine_name)
    engines_api.get_engine_persistant_services({engine_name: engine_name}).values
  end

  def consumers(engine_name)
    consumers_hash(engine_name).values
  end

  def databases(engine_name)
    databases_hash(engine_name) #.values James is passing array instead of hash.
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