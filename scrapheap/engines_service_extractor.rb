module EnginesServiceExtractor

  def volumes(service_name)
    volumes_hash(service_name).values
  end

  def self.variables_setup_params(type_path, publisher_namespace)
    engines_api.software_service_definition(
    publisher_namespace: publisher_namespace,
    type_path: type_path)[:setup_params]
  end


  # def registered_engines(service_name)
    # engines_api.registered_engines service_name
  # end

  # def databases(service_name)
  #   databases_hash(service_name)
  # end

  # def backup_tasks(service_name)
  #   EnginesBackupTask.all #.select { |backup_task| backup_task.present? }
  # end

end