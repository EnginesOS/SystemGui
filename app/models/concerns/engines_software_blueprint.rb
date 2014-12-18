module EnginesSoftwareBlueprint

  def software engine_name
    blueprint(engine_name)['software']
  end

  def repository engine_name
    blueprint(engine_name)["repository"]
  end

  def software_name engine_name
    software(engine_name)['name']
  end

end