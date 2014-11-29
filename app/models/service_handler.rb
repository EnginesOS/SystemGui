class ServiceHandler

  attr_accessor :id

  def initialize id
    @id = id
    @engines_api = EnginesApiHandler.engines_api
    @engine = @engines_api.getManagedService @id
  end

  def state
    @engine.read_state
  end

  def engine_name
    @engine.containerName
  end

  def fqdn
    @engine.fqdn
  end

  def state_as_set_by_user
    @engine.setState
  end

  def memory
    @engine.memory
  end

  def monitored
    @engine.monitored
  end

  def framework
    @engine.framework
  end

  def runtime
    @engine.runtime
  end

  def image
    @engine.image
  end

  def repo
    @engine.repo
  end

  def port
    @engine.port
  end

  def eports
    @engine.eports
  end

  def last_error
    @engine.last_error
  end

  def last_result
    @engine.last_result
  end

  def environments
    @engine.environments
  end

  def volumes
    @engine.volumes
  end

  def consumers
    @engine.consumers
  end

  def databases
    @engine.databases
  end

  def stats
    @engine.stats
  end

  def ps_container
    @engine.ps_container
  end

  def logs_container
    @engine.logs_container
  end

  def stop
    @engines_api.stopService @id
  end

  def start
    @engines_api.startService @id
  end
     
  def pause
    @engines_api.pauseService @id
  end
    
  def unpause
    @engines_api.unpauseService @id
  end
    
  def register_website
    @engines_api.registerServiceWebSite @id
  end
   
  def deregister_website
    @engines_api.deregisterServiceWebSite @id
  end

  def register_dns
    @engines_api.registerServiceDNS @id
  end
   
  def deregister_dns
    @engines_api.deregisterServiceDNS @id
  end

  def create_container
    @engines_api.createService @id
  end
    
  def recreate
    @engines_api.recreateService @id
  end

  def network_metrics
    @engines_api.get_container_network_metrics @id
  end

  def memory_statistics
    result = @engines_api.get_service_memory_statistics @id
    # if result != nil && result.instance_of?(Hash)
    #   return result
    # else
    #   return result.mesg  #EnginesOSapiResult object
    # end
  end

  ### Class methods

  def self.all
    EnginesApiHandler.engines_api.list_services.map do |service_name|
      ServiceHandler.new(service_name)
    end
  end


end