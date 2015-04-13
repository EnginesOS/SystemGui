module EnginesServiceExtractor

  def volumes(service_name)
    volumes_hash(service_name).values
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