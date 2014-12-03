class ServiceHandler

  # attr_accessor :service_name

  def initialize service_name
    @service_name = service_name
    # @engines_api = EnginesApiHandler.engines_api
    # @engine = @engines_api.getManagedService @service_name
  end

  def engines_api
    EnginesApiHandler.engines_api
  end

  def self.engines_api
    EnginesApiHandler.engines_api
  end

  def engine
    @engine ||= engines_api.getManagedService(@service_name)
  end

  def state
    engine.read_state
  end

  def engine_name
    engine.containerName
  end

  def fqdn
    engine.fqdn
  end

  def state_as_set_by_user
    engine.setState
  end

  def memory
    engine.memory
  end

  def monitored
    engine.monitored
  end

  def framework
    engine.framework
  end

  def runtime
    engine.runtime
  end

  def image
    engine.image
  end

  def repo
    engine.repo
  end

  def port
    engine.port
  end

  def eports
    engine.eports
  end

  def last_error
    engine.last_error
  end

  def last_result
    engine.last_result
  end

  def environments
    engine.environments
  end

  def volumes
    engine.volumes.values
  end

  def consumers
    engine.consumers
  end

  def databases
    engine.databases
  end

  def stats
    engine.stats
  end

  def ps_container
    engine.ps_container
  end

  def logs_container
    engine.logs_container
  end

  def stop
    engines_api.stopService @service_name
  end

  def start
    engines_api.startService @service_name
  end
     
  def pause
    engines_api.pauseService @service_name
  end
    
  def unpause
    engines_api.unpauseService @service_name
  end
    
  def register_website
    engines_api.registerServiceWebSite @service_name
  end
   
  def deregister_website
    engines_api.deregisterServiceWebSite @service_name
  end

  def register_dns
    engines_api.registerServiceDNS @service_name
  end
   
  def deregister_dns
    engines_api.deregisterServiceDNS @service_name
  end

  def create_container
    engines_api.createService @service_name
  end
    
  def recreate
    engines_api.recreateService @service_name
  end

  def network_metrics
    engines_api.get_container_network_metrics @service_name
  end

  def memory_statistics
    result = engines_api.get_service_memory_statistics @service_name
    # if result != nil && result.instance_of?(Hash)
    #   return result
    # else
    #   return result.mesg  #EnginesOSapiResult object
    # end
  end

  ### Class methods

  def self.all
    engines_api.list_services.map do |service_name|
      ServiceHandler.new(service_name)
    end
  end


end