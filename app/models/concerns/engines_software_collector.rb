module EnginesSoftwareCollector

  def all_engine_names
    engines = engines_api.list_apps
    if engines.kind_of?(EnginesOSapiResult)
      []
    else
      engines
    end
  end

  def all_host_names
    all_engine_names.map do |engine_name|
      engine = engines_software(engine_name)
      if engine.kind_of?(EnginesOSapiResult)
        next
      else
        engine.hostName
      end
    end
  end

  def all_fqdns
    all_engine_names.map do |engine_name|
      engine = engines_software(engine_name)
      if engine.kind_of?(EnginesOSapiResult)
        next
      else
        engine.fqdn
      end
    end
  end

  def count
    all_engine_names.count
  end

end