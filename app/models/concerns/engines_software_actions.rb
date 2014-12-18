module EnginesSoftwareActions

  def stop engine_name
    engines_api.stopEngine engine_name
  end
  
  def start engine_name
    engines_api.startEngine engine_name
  end
  
  def pause engine_name
    engines_api.pauseEngine engine_name
  end
  
  def unpause engine_name
    engines_api.unpauseEngine engine_name
   end
   
  def destroy_container engine_name
    engines_api.destroyEngine engine_name
  end 
  
  def delete_image engine_name
    engines_api.deleteEngineImage engine_name
  end 
  
  def restart engine_name
    engines_api.restartEngine engine_name
  end
  
  def create_container engine_name
    engines_api.createEngine engine_name
  end

  def recreate engine_name
    engines_api.recreateEngine engine_name
  end

  def monitor engine_name
    engines_api.monitorEngine engine_name
  end
  
  def demonitor engine_name
    engines_api.demonitorEngine engine_name
  end
  
  def register_website engine_name
    engines_api.registerEngineWebSite engine_name
  end
  
  def deregister_website engine_name
    engines_api.deregisterEngineWebSite engine_name    
  end
  
  def register_dns engine_name
    engines_api.registerEngineDNS engine_name
  end
  
  def deregister_dns engine_name
    engines_api.deregisterEngineDNS engine_name
  end

  def network_metrics engine_name
    engines_api.get_container_network_metrics engine_name
  end

  def memory_statistics engine_name
    engines_api.get_engine_memory_statistics engine_name
  end

end