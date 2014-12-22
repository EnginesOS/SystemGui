module EnginesSoftwareExtractor

  def blueprint_software_details(engine_name)
    blueprint(engine_name)['software']
  end

  # def repository_url engine_name(engine_name)
  #   blueprint(engine_name)["repository"]
  # end

  def blueprint_software_name(engine_name)
    blueprint_software_details(engine_name)['name']
  end

  def environment_variables(engine_name)
    environments(engine_name).map(&:attributes)
  end

  def volumes(engine_name)
    volumes_hash(engine_name).values
  end

  def consumers(engine_name)
    consumers_hash(engine_name).values
  end

  # def databases(engine_name)
  #   databases_hash(engine_name)
  # end

  def backup_tasks(engine_name)
    EnginesBackupTask.all #.select { |backup_task| backup_task.present? }
  end

end