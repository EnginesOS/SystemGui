
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
  
  def loadManagedEngine params
    return ManagedEngine.load(params)
  end
  
 
   
   def stopEngine params
     engine = loadManagedEngine params
     engine.stop_container
   end
   
   def startEngine params
     engine = loadManagedEngine params
     engine.start_container
   end
   
   def pauseEngine params
     engine = loadManagedEngine params
     engine.pause_container
   end
   
   def unpauseEngine params
     engine = loadManagedEngine params
     engine.unpause_container
   end
  
    def destroyEngine params
      engine = loadManagedEngine params
      engine.destroy_container
    end
    
   def deleteEngineImage params 
     engine = loadManagedEngine params
     engine.delete_container
   end
    
   def createEngine params
     engine = loadManagedEngine params
     engine.create_container
   end
   
   def restartEngine params
     engine = loadManagedEngine params
     engine.restart_container
   end
  
   def registerEngineWebSite params
     engine = loadManagedEngine params
     engine.register_site
   end
   
   def unregisterEngineWebSite params
     engine = loadManagedEngine params
     engine.unregister_site 
   end
   
   def monitorEngine params
     engine = loadManagedEngine params
     engine.monitor_site   
   end
   
   def demonitorEngine params
     engine = loadManagedEngine params
     engine.unmonitor_site
   end
   
   
  def getManagedServices
      return ManagedService.getManagedEngines()
    end
    
    def loadManagedService params
      return ManagedService.load(params)
    end
end
