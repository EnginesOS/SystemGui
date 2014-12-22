module EnginesSoftwareCollector

  def all_engine_names
    engines_api.list_apps
  end

  def all_host_names
    all_engine_names.map { |engine_name| engines_software(engine_name).hostName }
  end

  def count
    all_engine_names.count
  end

end