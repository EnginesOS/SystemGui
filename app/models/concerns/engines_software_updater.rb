module EnginesSoftwareUpdater

  def update_hostname_properties (params)
    engines_api.set_engine_hostname_properties params
  end

  def update_network_properties (params)
    engines_api.set_engine_network_properties params
  end

  def update_runtime (params)
    engines_api.set_engine_runtime params
  end

end