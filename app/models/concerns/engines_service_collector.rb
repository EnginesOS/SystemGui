module EnginesServiceCollector

  extend EnginesApi

  def all_service_names
    engines_api.list_services
  end

  def available_services_for engine_name
    engines_api.list_avail_services_for(EnginesSoftware.engines_software(engine_name))
  end

end