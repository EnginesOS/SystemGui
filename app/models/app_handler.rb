class AppHandler

  def initialize id
    @id = id
  end

  def engines_api
    EnginesApiHandler.engines_api
  end 

  def app_install
    app_install = AppInstall.find_by engine_name: @id
    if app_install.nil?
      app_install = AppInstall.new_from_engine @id
    end
    return app_install
  end

  def engine
    engines_api.loadManagedEngine @id
  end

  def blueprint
    engines_api.get_engine_blueprint @id
  end

  def update_engine
    engines_api.set_engine_hostname_details(
      engine_name: engine_name,
      host_name: host_name,
      domain_name: domain_name
    )
  end

  def stop
    engines_api.stopEngine @id
  end
  
  def start   
    engines_api.startEngine @id
  end
  
  def pause
    engines_api.pauseEngine @id
  end
  
  def unpause
    engines_api.unpauseEngine @id
   end
   
  def destroy_container
    engines_api.destroyEngine @id
  end 
  
  def delete_image
    engines_api.deleteEngineImage @id
  end 
  
  def restart
    engines_api.restartEngine @id
  end
  
  def create_container
    engines_api.createEngine @id
  end

  def recreate
    engines_api.recreateEngine @id
  end

  def monitor
    engines_api.monitorEngine @id
  end
  
  def demonitor
    engines_api.demonitorEngine @id
  end
  
  def register_website
    engines_api.registerEngineWebSite @id
  end
  
  def deregister_website
    engines_api.deregisterEngineWebSite @id    
  end
  
  def register_dns
    engines_api.registerEngineDNS @id
  end
  
  def deregister_dns
    engines_api.deregisterEngineDNS @id    
  end

  def software_definition
    blueprint['software']
  end

  def state
    engine.read_state
  end

  def engine_name
    engine.containerName
  end

  def host_name
    engine.hostName
  end

  def domain_name
    engine.domainName
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
    engine.volumes
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





  ### Class methods

  def self.all
    EnginesApiHandler.engines_api.list_apps.map do |engine_name|
      AppHandler.new(engine_name)
    end
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

