module EnginesSoftwareInspector

  def state engine_name
    engines_software(engine_name).read_state
  end

  def host_name engine_name
    engines_software(engine_name).hostName
  end

  def http_protocol engine_name
    engines_software(engine_name).http_protocol
  end

  def domain_name engine_name
    engines_software(engine_name).domainName
  end

  ### proposed method for when James adds gallery details to en engines software installation.
  # def gallery_server_name engine_name
  #   engines_software(engine_name).galleryServerName
  # end

  def fqdn engine_name
    engines_software(engine_name).fqdn
  end

  def state_as_set_by_user engine_name
    engines_software(engine_name).setState
  end

  def memory engine_name
    engines_software(engine_name).memory
  end

  def monitored engine_name
    engines_software(engine_name).monitored
  end

  def framework engine_name
    engines_software(engine_name).framework
  end

  def runtime engine_name
    engines_software(engine_name).runtime
  end

  def image engine_name
    engines_software(engine_name).image
  end

  def repo engine_name
    engines_software(engine_name).repo
  end

  def port engine_name
    engines_software(engine_name).port
  end

  def eports engine_name
    engines_software(engine_name).eports
  end

  def last_error engine_name
    engines_software(engine_name).last_error
  end

  def last_result engine_name
    engines_software(engine_name).last_result
  end

  def environments engine_name
    engines_software(engine_name).environments
  end

  def volumes engine_name
    engines_software(engine_name).volumes.values
  end

  def consumers engine_name
    engines_software(engine_name).consumers
  end

  def databases engine_name
    engines_software(engine_name).databases
  end

  def stats engine_name
    engines_software(engine_name).stats
  end

  def ps_container engine_name
    engines_software(engine_name).ps_container
  end

  def logs_container engine_name
    engines_software(engine_name).logs_container
  end

end