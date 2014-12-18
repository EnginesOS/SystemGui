module SoftwareHelper

  def engines_software_state engine_name
    EnginesSoftware.state engine_name
  end

  def engines_software_fqdn engine_name
    EnginesSoftware.fqdn engine_name
  end

  def engines_software_name_from_blueprint engine_name
    EnginesSoftware.software_name engine_name
  end

end
