module Engines::Application

  include Engines::Api

  def container
    @container ||= engines_api.loadManagedEngine container_name
  end
      
  def blueprint_software_details
    blueprint['software']
  end

  def blueprint_software_name
      blueprint_software_details['name']
  end

  def services_properties
    @services_properties ||= attached_services_hash
  end  

  def state_indicator
    if is_error?
      'error'
    else
      state
    end
  end
   
  def state
    @state ||= load_state
  end

  def load_state
      result = container.read_state.to_s
      if result == 'nocontainer'
        'unbuilt'
      else
        result
      end
  end
  
  def primary_web_site
    if web_sites.present?
      web_sites.first
    else
      nil
    end
  end

  {
    active?: 'is_active?',
    is_running: 'is_running?',
    is_error?: 'is_error?',
    has_container?: 'has_container?',
    container_type: 'ctype',
    host_name: 'hostname',
    http_protocol: 'http_protocol',
    http_protocol_as_sym: 'protocol',
    https_only: 'https_only',
    domain_name: 'domain_name',
    web_sites: 'web_sites',
    default_startup_state: 'setState',
    memory: 'memory',
    monitored: 'monitored',
    framework: 'framework',
    runtime: 'runtime',
    image: 'image',
    repository: 'repository',
    port: 'web_port',
    external_ports: 'eports',
    last_error: 'last_error',
    last_result: 'last_result',
    stats: 'stats',
    ps_container: 'ps_container',
    logs_container: 'logs_container',
    environments: 'environments',
    volumes_hash: 'volumes',
    consumers_hash: 'consumers'
  }.
  each do |method, instruction|
    define_method(method) do
      container.send(instruction)
    end
  end

  def blueprint
    @blueprint ||= engines_api.get_engine_blueprint(container_name)
  end

  def network_metrics
    engines_api.get_container_network_metrics(container_name)
  end
  
  def memory_statistics
    engines_api.get_engine_memory_statistics(container_name)
  end
 
  def installation_report
    engines_api.get_engine_build_report(container_name)
  end
 
  def attached_services_hash
    @attached_services_hash ||= engines_api.list_attached_services_for('ManagedEngine', container_name)
  end
 
   def available_services_hash
    @available_services_hash ||= engines_api.list_avail_services_for container
  end

  def available_services
    available_services_hash[:services]
  end
      
  {
    stop: 'stopEngine',  
    start: 'startEngine',  
    pause: 'pauseEngine',  
    unpause: 'unpauseEngine',   
    destroy_container: 'destroyEngine',
    reinstall_software: 'reinstall_engine',  
    restart: 'restartEngine',  
    create_container: 'createEngine',
    recreate: 'recreateEngine'
  }.
  each do |method, instruction|
    define_method(method) do |options={}|
      if options.present?
        engines_api.send(instruction, container_name, options )
      else
        engines_api.send(instruction, container_name )
      end
    end
  end

end