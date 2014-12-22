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
    define_method(method) { |engine_name| engines_api.send(instruction, engine_name) }
  end

end



# module EnginesSoftwareInstructor

#   def stop(engine_name)
#     engines_api.stopEngine engine_name
#   end
  
#   def start(engine_name)
#     engines_api.startEngine engine_name
#   end
  
#   def pause(engine_name)
#     engines_api.pauseEngine engine_name
#   end
  
#   def unpause(engine_name)
#     engines_api.unpauseEngine engine_name
#    end
   
#   def destroy_container(engine_name)
#     engines_api.destroyEngine engine_name
#   end 
  
#   def delete_image(engine_name)
#     engines_api.deleteEngineImage engine_name
#   end 
  
#   def restart(engine_name)
#     engines_api.restartEngine engine_name
#   end
  
#   def create_container(engine_name)
#     engines_api.createEngine engine_name
#   end

#   def recreate(engine_name)
#     engines_api.recreateEngine engine_name
#   end

#   def monitor(engine_name)
#     engines_api.monitorEngine engine_name
#   end
  
#   def demonitor(engine_name)
#     engines_api.demonitorEngine engine_name
#   end
  
#   def register_website(engine_name)
#     engines_api.registerEngineWebSite engine_name
#   end
  
#   def deregister_website(engine_name)
#     engines_api.deregisterEngineWebSite engine_name    
#   end
  
#   def register_dns(engine_name)
#     engines_api.registerEngineDNS engine_name
#   end
  
#   def deregister_dns(engine_name)
#     engines_api.deregisterEngineDNS engine_name
#   end

#   def network_metrics(engine_name)
#     engines_api.get_container_network_metrics engine_name
#   end

#   def memory_statistics(engine_name)
#     engines_api.get_engine_memory_statistics engine_name
#   end

# end