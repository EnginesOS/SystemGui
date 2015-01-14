module EnginesServiceInspector

  {
    state: 'read_state',
    fqdn: 'fqdn',
    state_as_set_by_user: 'setState',
    memory: 'memory',
    monitored: 'monitored',
    framework: 'framework',
    runtime: 'runtime',
    image: 'image',
    repo: 'repo',
    port: 'port',
    eports: 'eports',
    last_error: 'last_error',
    last_result: 'last_result',
    environments: 'environments',
    volumes_hash: 'volumes',
    consumers: 'consumers',
    databases: 'databases',
    stats: 'stats',
    ps_container: 'ps_container',
    logs_container: 'logs_container'
  }.
  each do |method, instruction|
    define_method(method) do |service_name|
      result = send(:engines_service, service_name)
      if result.kind_of?(EnginesOSapiResult)
        result
      else
        result.send(instruction)
      end
    end
  end

end

  # def engine_name service_name
  #   engines_service(service_name).containerName
  # end

 