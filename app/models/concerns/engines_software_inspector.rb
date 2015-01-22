module EnginesSoftwareInspector

  {
    state: 'read_state',
    is_active: 'is_active',
    host_name: 'hostName',
    http_protocol: 'http_protocol',
    domain_name: 'domainName',
    fqdn: 'fqdn',
    default_startup_state: 'setState',
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
    stats: 'stats',
    ps_container: 'ps_container',
    logs_container: 'logs_container',
    environments: 'environments',
    volumes_hash: 'volumes',
    consumers_hash: 'consumers',
    # databases_hash: 'databases',
    attached_services_hash: 'attached_services'
  }.
  each do |method, instruction|
    define_method(method) do |engine_name| 
      software = send(:engines_software, engine_name)
      if software.kind_of?(EnginesOSapiResult)
        return software
      else
        software.send(instruction)
      end
    end
  end

end
