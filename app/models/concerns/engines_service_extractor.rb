module EnginesServiceExtractor

  def volumes(service_name)
    volumes_hash(service_name).values
  end

  # def consumers(service_name)
  #   consumers_hash(service_name).values
  # end

  # def databases(service_name)
  #   databases_hash(service_name)
  # end

  # def backup_tasks(service_name)
  #   EnginesBackupTask.all #.select { |backup_task| backup_task.present? }
  # end

end