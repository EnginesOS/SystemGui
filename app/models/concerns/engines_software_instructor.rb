module EnginesSoftwareInstructor

  {
    engines_software: 'loadManagedEngine',
    blueprint: 'get_engine_blueprint',
    stop: 'stopEngine',  
    start: 'startEngine',  
    pause: 'pauseEngine',  
    unpause: 'unpauseEngine',   
    destroy_container: 'destroyEngine',
    reinstall_software: 'reinstall_engine',  
    delete_image: 'deleteEngineImage',  
    restart: 'restartEngine',  
    create_container: 'createEngine',
    recreate: 'recreateEngine',
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