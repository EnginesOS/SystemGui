module EnginesService

  extend EnginesApi

  def self.all_engine_names
    engines_api.list_services
  end

  def self.get_services_available_for ojbect
  end


  def self.engines_service service_name
    engines_api.getManagedService service_name
  end

  def self.state service_name
    engines_service(service_name).read_state
  end

  # def engine_name service_name
  #   engines_service(service_name).containerName
  # end

  def self.fqdn service_name
    engines_service(service_name).fqdn
  end

  def state_as_set_by_user service_name
    engines_service(service_name).setState
  end

  def memory service_name
    engines_service(service_name).memory
  end

  def monitored service_name
    engines_service(service_name).monitored
  end

  def framework service_name
    engines_service(service_name).framework
  end

  def runtime service_name
    engines_service(service_name).runtime
  end

  def image service_name
    engines_service(service_name).image
  end

  def repo service_name
    engines_service(service_name).repo
  end

  def port service_name
    engines_service(service_name).port
  end

  def eports service_name
    engines_service(service_name).eports
  end

  def last_error service_name
    engines_service(service_name).last_error
  end

  def last_result service_name
    engines_service(service_name).last_result
  end

  def environments service_name
    engines_service(service_name).environments
  end

  def volumes service_name
    engines_service(service_name).volumes.values
  end

  def consumers service_name
    engines_service(service_name).consumers
  end

  def databases service_name
    engines_service(service_name).databases
  end

  def stats service_name
    engines_service(service_name).stats
  end

  def ps_container service_name
    engines_service(service_name).ps_container
  end

  def logs_container service_name
    engines_service(service_name).logs_container
  end

  def stop service_name
    engines_api.stopService service_name
  end

  def start service_name
    engines_api.startService service_name
  end
     
  def pause service_name
    engines_api.pauseService service_name
  end
    
  def unpause service_name
    engines_api.unpauseService service_name
  end
    
  def register_website service_name
    engines_api.registerServiceWebSite service_name
  end
   
  def deregister_website service_name
    engines_api.deregisterServiceWebSite service_name
  end

  def register_dns service_name
    engines_api.registerServiceDNS service_name
  end
   
  def deregister_dns service_name
    engines_api.deregisterServiceDNS service_name
  end

  def create_container service_name
    engines_api.createService service_name
  end
    
  def recreate service_name
    engines_api.recreateService service_name
  end

  def network_metrics service_name
    engines_api.get_container_network_metrics service_name
  end

  def memory_statistics service_name
    result = engines_api.get_service_memory_statistics service_name
    # if result != nil && result.instance_of?(Hash)
    #   return result
    # else
    #   return result.mesg  #EnginesOSapiResult object
    # end
  end

  
end