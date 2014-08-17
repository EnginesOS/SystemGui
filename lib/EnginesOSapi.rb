
require "/opt/engos/lib/ruby/ManagedContainer.rb"
require "/opt/engos/lib/ruby/SysConfig.rb"
require "/opt/engos/lib/ruby/ManagedEngine.rb"
require "/opt/engos/lib/ruby/ManagedService.rb"
require "/opt/engos/lib/ruby/NginxService.rb"
require "/opt/engos/lib/ruby/NagiosService.rb"

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
    
#At this stage just wrappers

  def getManagedEngines
    return getManagedContainers("container")
  end
  
  def getManagedServices
      return getManagedContainers("service")
    end
  
  def getManagedContainers(type)
         ret_val=Array.new
            Dir.entries(SysConfig.CidDir + "/" + type + "s/").each do |contdir|
              yfn = SysConfig.CidDir + "/" + type + "s/" + contdir + "/config.yaml"     
              if File.exists?(yfn) == true           
                yf = File.open(yfn)   
                managed_container = ManagedContainer.from_yaml(yf)          
                if managed_container                            
                  ret_val.push(managed_container)
                end
                yf.close
              end
            end
            return ret_val
       end
 
       
  def loadManagedEngine(container_name)
      return loadManagedContainer(container_name,"container")            
  end
  
  def loadManagedService(service_name)
    return loadManagedContainer(service_name,"service")
  end
  
  def loadManagedContainer(container_name,type)
       yam_file_name = SysConfig.CidDir + "/" + type + "s/" + container_name + "/config.yaml"
      
         if File.exists?(yam_file_name) == false
           puts("No such configuration:" + yam_file_name )
           return nil
         end 
         
       yaml_file = File.open(yam_file_name) 
       managed_container = YAML::load( yaml_file)
      return managed_container
     end
     
  #def loadManagedEngine container_name
  #  engine = ManagedEngine.load(container_name)
   # if engine == nil      
    #  return false
    #end
    #return engine
  #end
  
 
   
   def stopEngine container_name 
     engine = loadManagedEngine container_name
     if engine == nil
       return false   
     end  
     return engine.stop_container(@docker_api)     
   end
   
   def startEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false    
     end
     return engine.start_container(@docker_api)     
   end
   
   def pauseEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end    
     return engine.pause_container(@docker_api)       
   end
   
   def unpauseEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end
     return engine.unpause_container(@docker_api)     
   end
  
    def destroyEngine container_name
      engine = loadManagedEngine container_name
      if engine == nil
        return false
      end
      return engine.destroy_container(@docker_api)     
    end
    
   def deleteEngineImage container_name 
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end
    return engine.delete_container(@docker_api)     
   end
    
   def createEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end
    return engine.create_container(@docker_api)     
   end
   
   def restartEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end
     return engine.restart_container(@docker_api)     
   end
  
   def registerEngineWebSite container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end
     return  engine.register_site(@docker_api)     
   end
   
   def deregisterEngineWebSite container_name
     engine = loadManagedEngine container_name
       if engine == nil
        return false
       end
    return engine.unregister_site(@docker_api)     
   end
   
   def monitorEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end
     return engine.monitor_site(@docker_api)       
   end
   
   def demonitorEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end         
     return engine.demonitor_site(@docker_api)     
   end
   
   def read_state container
     return container.read_state(@docker_api)
   end
   
 
    
   
    
    
    def stopService service_name
      service = loadManagedService(service_name)
      if service == nil
        return false
      end      
      return service.stop_container(@docker_api)        
    end
    
    def startService service_name
      service = loadManagedService(service_name)
            if service == nil
              return false
            end      
            return service.start_container(@docker_api)    
    end
    
    def  pauseService service_name
      service = loadManagedService(service_name)
            if service == nil
              return false
            end      
            return service.pause_container(@docker_api)     
    end
    
    def  unpauseService service_name
      service = loadManagedService(service_name)
             if service == nil
               return false
             end      
        return service.unpause_container(@docker_api)      
    end
    
     def registerServiceWebSite service_name
       service = loadManagedService(service_name)
               if service == nil
                 return false
               end      
          return service.register_site(@docker_api)    
     end
     
    def deregisterServiceWebSite service_name
      service = loadManagedService(service_name)
           if service == nil
               return false
            end      
        return service.deregister_site(@docker_api)     
    end
    
    def createService service_name
      service = loadManagedService(service_name)
           if service == nil
               return false
            end      
        return service.create_service(@docker_api)
    end
    
    def recreateService service_name
      service = loadManagedService(service_name)
           if service == nil
               return false
            end      
        return service.recreate(@docker_api)      
    end
end
