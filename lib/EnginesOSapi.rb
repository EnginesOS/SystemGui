
require "/opt/engos/lib/ruby/ManagedContainer.rb"
require "/opt/engos/lib/ruby/SysConfig.rb"
require "/opt/engos/lib/ruby/ManagedEngine.rb"
require "/opt/engos/lib/ruby/ManagedService.rb"
require "/opt/engos/lib/ruby/NginxService.rb"
require "/opt/engos/lib/ruby/NagiosService.rb"

class EnginesOSapi
  def initialize()
      
  end
    
#At this stage just wrappers

  def getManagedEngines
    return ManagedEngine.getManagedEngines()
  end
  
  def loadManagedEngine container_name
    engine = ManagedEngine.load(container_name)
    if engine == nil
      return false
    end
    return engine
  end
  
 
   
   def stopEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false   
     end  
     return engine.stop_container     
   end
   
   def startEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false    
     end
     return engine.start_container
   end
   
   def pauseEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end    
     return engine.pause_container     
   end
   
   def unpauseEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end
     return engine.unpause_container
   end
  
    def destroyEngine container_name
      engine = loadManagedEngine container_name
      if engine == nil
        return false
      end
      return engine.destroy_container
    end
    
   def deleteEngineImage container_name 
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end
    return engine.delete_container
   end
    
   def createEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end
    return engine.create_container
   end
   
   def restartEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end
     return engine.restart_container
   end
  
   def registerEngineWebSite container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end
     return  engine.register_site
   end
   
   def deregisterEngineWebSite container_name
     engine = loadManagedEngine container_name
       if engine == nil
        return false
       end
    return engine.unregister_site 
   end
   
   def monitorEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end
     return engine.monitor_site   
   end
   
   def demonitorEngine container_name
     engine = loadManagedEngine container_name
     if engine == nil
       return false
     end         
     return engine.demonitor_site
   end
   
   
  def getManagedServices
      return ManagedService.getManagedServices()
    end
    
    def loadManagedService container_name
      return ManagedService.load(container_name)
    end
    
    def stopService container_name
      service = ManagedService.load(container_name)
      if service == nill
        return false
      end      
      return service.stop_container      
    end
    
    def startService container_name
      service = ManagedService.load(container_name)
            if service == nill
              return false
            end      
            return service.stop_container    
    end
    
    def  pauseService container_name
      service = ManagedService.load(container_name)
            if service == nill
              return false
            end      
            return service.pause_container      
    end
    
    def  unpauseService container_name
      service = ManagedService.load(container_name)
             if service == nill
               return false
             end      
        return service.unpause_container      
    end
    
     def registerServiceWebSite container_name
       service = ManagedService.load(container_name)
               if service == nill
                 return false
               end      
          return service.register_site     
     end
     
    def deregisterServiceWebSite container_name
      service = ManagedService.load(container_name)
           if service == nill
               return false
            end      
        return service.deregister_site     
    end
    
    def createService container_name
      service = ManagedService.load(container_name)
           if service == nill
               return false
            end      
        return service.create_service
    end
    
    def recreateService container_name
      service = ManagedService.load(container_name)
           if service == nill
               return false
            end      
        return service.recreate      
    end
end
