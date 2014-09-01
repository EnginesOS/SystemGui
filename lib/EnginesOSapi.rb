require "/opt/engos/lib/ruby/ManagedContainer.rb"
require "/opt/engos/lib/ruby/SysConfig.rb"
require "/opt/engos/lib/ruby/ManagedEngine.rb"
require "/opt/engos/lib/ruby/ManagedService.rb"
require "/opt/engos/lib/ruby/NginxService.rb"
require "/opt/engos/lib/ruby/NagiosService.rb"
require "/opt/engos/lib/ruby/EngineBuilder.rb"

class EnginesOSapi
  def initialize()
    @docker_api = Docker.new
  end

  def docker_api
    return @docker_api
  end

  #hmm something like this to get errors back

  class  EnginesOSapiResult
    def initialize(result,code,item_name, msg)
      @was_sucess=result
      @result_code = code
      @item_name = item_name
      @result_mesg = error_msg
    end

    def initialize(item_name)
      @was_sucess=true
      @result_code = 0
      @item_name = item_name
      @result_mesg = "OK"
    end
  end

  def buildEngine(repository,host,domain_name,environment)
    engine_builder = EngineBuilder.new(repository,host,domain_name,environment)
    engine = engine_builder.build_from_blue_print
    engine.set_docker_api  docker_api
    engine.save_state
    return engine

  end

  def getManagedEngines()
    ret_val=Array.new
    Dir.entries(SysConfig.CidDir + "/containers/").each do |contdir|
      yfn = SysConfig.CidDir + "/containers/" + contdir + "/config.yaml"
      if File.exists?(yfn) == true
        yf = File.open(yfn)
        managed_engine = ManagedEngine.from_yaml(yf,@docker_api)
        if managed_engine
          ret_val.push(managed_engine)
        end
        yf.close
      end
    end
    return ret_val
  end

  def getManagedServices()
    ret_val=Array.new
    Dir.entries(SysConfig.CidDir + "/services/").each do |contdir|
      yfn = SysConfig.CidDir + "/services/" + contdir + "/config.yaml"
      if File.exists?(yfn) == true
        yf = File.open(yfn)
        managed_service = ManagedService.from_yaml(yf,@docker_api)
        if managed_service
          ret_val.push(managed_service)
        end
        yf.close
      end
    end
    return ret_val
  end

  def loadManagedService(service_name)

    managed_service = EnginesOSapi.loadManagedService(service_name,@docker_api)

    return managed_service
  end

  def EnginesOSapi.loadManagedService(service_name,docker_api)
    yam_file_name = SysConfig.CidDir + "/services/" + service_name + "/config.yaml"

    if File.exists?(yam_file_name) == false
      puts("No such configuration:" + yam_file_name )
      return failed(yam_file_name,"No such configuration:")
    end

    yaml_file = File.open(yam_file_name)
    # managed_service = YAML::load( yaml_file)
    managed_service = ManagedService.from_yaml(yaml_file,docker_api)

    return managed_service
  end

  def loadManagedEngine(engine_name)
    yam_file_name = SysConfig.CidDir + "/containers/" + engine_name + "/config.yaml"

    if File.exists?(yam_file_name) == false
      puts("No such configuration:" + yam_file_name )
      return failed(yam_file_name,"No such configuration:")
    end

    yaml_file = File.open(yam_file_name)
    managed_engine = ManagedEngine.from_yaml( yaml_file,@docker_api)
    return managed_engine
  end

  #At this stage just wrappers

  def stopEngine engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      retval=false

    end
    retval = engine.stop_container()
    if retval == false
      return failed(engine.name,"No Engine")
    else
      return sucess(engine.name)
    end
  end

  def startEngine engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end

    retval =  engine.start_container()

    if retval == false
      return failed(engine_name,engine.last_error)
    end

    return sucess(engine_name)

  end

  def pauseEngine engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end

    retval = engine.pause_container

    if retval == false
      return failed(engine_name,engine.last_error)
    end
    return sucess(engine_name)

  end

  def unpauseEngine engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end
    retval =  engine.unpause_container()
    if retval == false
      return failed(engine_name,engine.last_error)
    end
    return sucess(engine_name)

  end

  def destroyEngine engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end
    retval =   engine.destroy_container()
    if retval == false
      return failed(engine_name,engine.last_error)
    end
    return sucess(engine_name)
  end

  def deleteEngineImage engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end
    retval =   engine.delete_image()
    if retval == false
      return failed(engine_name,engine.last_error)
    end
    return sucess(engine_name)
  end

  def createEngine engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end
    retval =   engine.create_container()
    if retval == false
      return failed(engine_name,engine.last_error)
    end
    return sucess(engine_name)
  end

  def restartEngine engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end
    retval =   engine.restart_container()
    if retval == false
      return failed(engine_name,engine.last_error)
    end
    return sucess(engine_name)
  end

  def registerEngineWebSite engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end
    retval =  engine.register_site()
    if retval == false
      return failed(engine_name,engine.last_error)
    end
    return sucess(engine_name)
  end

  def deregisterEngineWebSite engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end
    retval =   engine.deregister_site()
    if retval == false
      return failed(engine_name,engine.last_error)
    end
    return sucess(engine_name)
  end

  def registerEngineDNS engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end
    retval  engine.register_dns()
    if retval == false
      return failed(engine_name,engine.last_error)
    end
    return sucess(engine_name)
  end

  def deregisterEngineDNS engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end
    retval = engine.deregister_dns()
    if retval == false
      return failed(engine_name,engine.last_error)
    end
    return sucess(engine_name)
  end

  def monitorEngine engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end
    retval engine.monitor_site()
    if retval == false
      return failed(engine_name,engine.last_error)
    end
    return sucess(engine_name)
  end

  def demonitorEngine engine_name
    engine = loadManagedEngine engine_name
    if engine == nil
      return failed(engine_name,"no Engine")
    end
    retval = engine.demonitor_site()
    if retval == false
      return failed(engine_name,engine.last_error)
    end
    return sucess(engine_name)
  end

  def read_state container
    retval =   container.read_state()
    if retval == false
      return failed(container.name)
    end
    return sucess(container.name)
  end

  def stopService service_name
    service = loadManagedService(service_name)
    if service == nil
      return failed(service_name,"No Such Service")
    end
    retval =   service.stop_container()
    if retval == false
      return failed(service_name,service.last_error)
    end
    return sucess(engine_name)
  end

  def startService service_name
    service = loadManagedService(service_name)
    if service == nil
      return failed(service_name,"No Such Service")
    end
    retval service.start_container()
    if retval == false
      return failed(service_name,service.last_error)
    end
    return sucess(engine_name)
  end

  def  pauseService service_name
    service = loadManagedService(service_name)
    if service == nil
      return failed(service_name,"No Such Service")
    end
    retval service.pause_container()
    if retval == false
      return failed(service_name,service.last_error)
    end
    return sucess(engine_name)
  end

  def  unpauseService service_name
    service = loadManagedService(service_name)
    if service == nil
      return failed(service_name,"No Such Service")
    end
    retval service.unpause_container()
    if retval == false
      return failed(service_name,service.last_error)
    end
    return sucess(engine_name)
  end

  def registerServiceWebSite service_name
    service = loadManagedService(service_name)
    if service == nil
      return failed(service_name,"No Such Service")
    end
    retval =   service.register_site()
    if retval == false
      return failed(service_name,service.last_error)
    end
    return sucess(engine_name)
  end

  def deregisterServiceWebSite service_name
    service = loadManagedService(service_name)
    if service == nil
      return  failed(service_name,"No Such Service")
    end
    retval =   service.deregister_site()
    if retval == false
      return failed(service_name,service.last_error)
    end
    return sucess(engine_name)
  end

  def registerServiceDNS service_name
    service = loadManagedService(service_name)
    if service == nil
      return  failed(service_name,service.last_error)
    end
    retval =   service.register_dns()
    if retval == false
      return failed(service_name,service.last_error)
    end
    return sucess(engine_name)
  end

  def deregisterServiceDNS service_name
    service = loadManagedService(service_name)
    if service == nil
      return  failed(service_name,service.last_error)
    end
    retval =   service.deregister_dns()
    if retval == false
      return failed(service_name,service.last_error)
    end
    return sucess(engine_name)
  end

  def createService service_name
    service = loadManagedService(service_name)
    if service == nil
      return  failed(service_name,service.last_error)
    end
    retval =   service.create_service()
    if retval == false
      return failed(service_name,service.last_error)
    end
    return sucess(engine_name)
  end

  def recreateService service_name
    service = loadManagedService(service_name)
    if service == nil
      return failed(service_name,"No Such Service")
    end
    retval =   service.recreate()
    if retval == false
      return failed(service_name,service.last_error)
    end
    return sucess(engine_name)
  end

  protected

  def sucess (item_name )
    return  EnginesOSapiResult.new(true,0,item_name, "OK")
  end

  def failed (item_name,mesg )
    return  EnginesOSapiResult.new(false,-1,item_name, mesg)
  end
end
