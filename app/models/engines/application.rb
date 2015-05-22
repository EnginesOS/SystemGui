module Engines::Application

  include Engines::Api

#loaders
      
  def container
    @container ||= engines_api.loadManagedEngine container_name
  end
      
#extractors

  def show_on_desktop?
    default_startup_state == 'running' || active?
  end


  def blueprint_software_details
    blueprint['software']
  end

  def blueprint_software_name
      blueprint_software_details['name']
  end

  # def volumes(container_name)
    # volumes_hash(container_name).values
  # end

  # def consumers(container_name)
    # consumers_hash(container_name).values
  # end

  # def backup_tasks(container_name)
    # EnginesBackupTask.all #.select { |backup_task| backup_task.present? }
  # end



#inspectors       
      
        {
    state: 'read_state',
    active?: 'is_active',
    is_running: 'is_running',
    is_error: 'is_error',
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
 
 
 
  def attached_services_hash
    @attached_services_hash ||= engines_api.list_attached_services_for('ManagedEngine', container_name)
  end
 
   def available_services_hash
    @available_services_hash ||= engines_api.list_avail_services_for container
  end

  def available_services
    available_services_hash[:services]
  end

 
 
 #instructors
      
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