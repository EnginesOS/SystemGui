module EnginesSoftwareInstructor

  {
    engines_software: 'loadManagedEngine',
    blueprint: 'get_engine_blueprint',
    stop: 'stopEngine',  
    start: 'startEngine',  
    pause: 'pauseEngine',  
    unpause: 'unpauseEngine',   
    destroy_container: 'destroyEngine',  
    delete_image: 'deleteEngineImage',  
    restart: 'restartEngine',  
    create_container: 'createEngine',
    recreate: 'recreateEngine',
    monitor: 'monitorEngine',  
    demonitor: 'demonitorEngine',  
    register_website: 'registerEngineWebSite',  
    deregister_website: 'deregisterEngineWebSite',  
    register_dns: 'registerEngineDNS',  
    deregister_dns: 'deregisterEngineDNS',
    network_metrics: 'get_container_network_metrics',
    memory_statistics: 'get_engine_memory_statistics'
  }.
  each do |method, instruction|
    define_method(method) do |engine_name, options={}|
      if options.present?
        engines_api.send(instruction, engine_name, options )
      else
        engines_api.send(instruction, engine_name )
      end
    end
  end

end