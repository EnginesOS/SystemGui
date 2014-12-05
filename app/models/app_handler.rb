class AppHandler

  attr_reader :engine_name

  def initialize engine_name
    @engine_name = engine_name
  end

  def engines_api
    EnginesApiHandler.engines_api
  end

  def self.engines_api
    EnginesApiHandler.engines_api
  end

  def app_install
    @app_install ||= AppInstall.find_or_create_by(engine_name: @engine_name) # || AppInstall.new_from_engine(@engine_name)
  end

  def engine
    @engine ||= engines_api.loadManagedEngine(@engine_name)
  end

  def blueprint
    @blueprint ||= engines_api.get_engine_blueprint @engine_name
    if @blueprint.is_a?(EnginesOSapiResult)
      {}
    else
      @blueprint
    end
  end

  def software
    blueprint['software']
  end

  def stop
    engines_api.stopEngine @engine_name
  end
  
  def start   
    engines_api.startEngine @engine_name
  end
  
  def pause
    engines_api.pauseEngine @engine_name
  end
  
  def unpause
    engines_api.unpauseEngine @engine_name
   end
   
  def destroy_container
    engines_api.destroyEngine @engine_name
  end 
  
  def delete_image
    engines_api.deleteEngineImage @engine_name
  end 
  
  def restart
    engines_api.restartEngine @engine_name
  end
  
  def create_container
    engines_api.createEngine @engine_name
  end

  def recreate
    engines_api.recreateEngine @engine_name
  end

  def monitor
    engines_api.monitorEngine @engine_name
  end
  
  def demonitor
    engines_api.demonitorEngine @engine_name
  end
  
  def register_website
    engines_api.registerEngineWebSite @engine_name
  end
  
  def deregister_website
    engines_api.deregisterEngineWebSite @engine_name    
  end
  
  def register_dns
    engines_api.registerEngineDNS @engine_name
  end
  
  def deregister_dns
    engines_api.deregisterEngineDNS @engine_name
  end

  def state
    engine.read_state
  end

  # def engine_name
  #   engine.containerName
  # end

  def host_name
    engine.hostName
  end

  def http_protocol
    engine.http_protocol
  end

  def domain_name
    dn = engine.domainName
p ':domain_name'
p dn
return dn
  end

  # def gallery_server_name
  #   engine.galleryServerName
  # end

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

  def network_metrics
    engines_api.get_container_network_metrics @engine_name
  end

  def memory_statistics
    engines_api.get_engine_memory_statistics @engine_name
  end

  ### Class methods

  def self.all
    self.engines_api.list_apps.map do |engine_name|
      AppHandler.new(engine_name)
    end
  end

  def self.all_engine_names
    self.all.map(&:engine_name)
  end

  def self.all_host_names
    self.all.map(&:engine_name)
  end

  def self.user_visible_applications
    all = self.all
    running_apps = []
    all.each do |app|
      if app.state_as_set_by_user == 'running'
        running_apps << app
      end
    end
    return running_apps
  end

end

