module EnginesSoftwareUpdater

  def update_host_name (params)
    engines_api.set_engine_hostname_properties params
  end

  def update_domain_name (params)
    engines_api.set_engine_network_properties params
  end

  def update_resources (params)
    engines_api.set_engine_runtime_properties params
  end

  def update_variables (params)
    engines_api.set_engine_runtime_properties params
  end

end