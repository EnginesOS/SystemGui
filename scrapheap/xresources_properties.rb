module Engines::ResourcesProperties

  def engines_api
    Engines::Api.instance.engines_api
  end

  def update_memory
    engines_api.set_engine_runtime_properties container_name: application.container_name, memory: memory
  end

end