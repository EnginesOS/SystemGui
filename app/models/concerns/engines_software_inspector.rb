module EnginesSoftwareInspector

  {
    state: 'read_state',
    host_name: 'hostName',
    http_protocol: 'http_protocol',
    domain_name: 'domainName',
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
    stats: 'stats',
    ps_container: 'ps_container',
    logs_container: 'logs_container',
    environments: 'environments',
    volumes_hash: 'volumes',
    consumers_hash: 'consumers',
    databases: 'databases'
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

# module EnginesSoftwareInspector

#   def blueprint_software_details(engine_name)
#     blueprint(engine_name)['software']
#   end

#   # def repository_url engine_name(engine_name)
#   #   blueprint(engine_name)["repository"]
#   # end

#   def blueprint_software_name(engine_name)
#     blueprint_software_details(engine_name)['name']
#   end


#   def engines_software(engine_name)
#     engines_api.loadManagedEngine engine_name
#   end

#   def blueprint(engine_name)
#     engines_api.get_engine_blueprint engine_name
#   end

#   def state(engine_name)
#     engines_software(engine_name).read_state
#   end

#   def host_name(engine_name)
#     engines_software(engine_name).hostName
#   end

#   def http_protocol(engine_name)
#     engines_software(engine_name).http_protocol
#   end

#   def domain_name(engine_name)
#     engines_software(engine_name).domainName
#   end

#   def fqdn(engine_name)
#     engines_software(engine_name).fqdn
#   end

#   def state_as_set_by_user(engine_name)
#     engines_software(engine_name).setState
#   end

#   def memory(engine_name)
#     engines_software(engine_name).memory
#   end

#   def monitored(engine_name)
#     engines_software(engine_name).monitored
#   end

#   def framework(engine_name)
#     engines_software(engine_name).framework
#   end

#   def runtime(engine_name)
#     engines_software(engine_name).runtime
#   end

#   def image(engine_name)
#     engines_software(engine_name).image
#   end

#   def repo(engine_name)
#     engines_software(engine_name).repo
#   end

#   def port(engine_name)
#     engines_software(engine_name).port
#   end

#   def eports(engine_name)
#     engines_software(engine_name).eports
#   end

#   def last_error(engine_name)
#     engines_software(engine_name).last_error
#   end

#   def last_result(engine_name)
#     engines_software(engine_name).last_result
#   end

#   def environment_variables(engine_name)
#     engines_software(engine_name).environments.map(&:attributes)
#   end

#   def volumes(engine_name)
#     engines_software(engine_name).volumes.values
#   end

#   def consumers(engine_name)
#     engines_software(engine_name).consumers
#   end

#   def databases(engine_name)
#     engines_software(engine_name).databases
#   end

#   def stats(engine_name)
#     engines_software(engine_name).stats
#   end

#   def ps_container(engine_name)
#     engines_software(engine_name).ps_container
#   end

#   def logs_container(engine_name)
#     engines_software(engine_name).logs_container
#   end

# end