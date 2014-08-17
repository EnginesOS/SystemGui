
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
  
  def getManagedServices
     return ManagedService.getManagedEngines()
   end
   
   def loadManagedService params
     return ManagedService.load(params)
   end
   
   def stopEngine params
     engine = loadManagedEngine params
     engine.stop_container
   end
   
   def startEngine
     engine = loadManagedEngine params
     engine.start_container
   end
   
   def pauseEngine
     engine = loadManagedEngine params
     engine.pause_container
   end
   
   def unpauseEngine
     engine = loadManagedEngine params
     engine.unpause_container
   end
  
    def destroyEngine
      engine = loadManagedEngine params
      engine.destroy_container
    end
    
   def deleteEngineImage
     engine = loadManagedEngine params
     engine.delete_container
   end
    
   def createEngine
     engine = loadManagedEngine params
     engine.create_container
   end
   
   def restartEngine
     engine = loadManagedEngine params
     engine.restart_container
   end
  
   def registerEngineWebSite
     engine = loadManagedEngine params
     engine.register_site
   end
   
   def unregisterEngineWebSite
     engine = loadManagedEngine params
     engine.unregister_site 
   end
   
   def monitorEngine
     engine = loadManagedEngine params
     engine.monitor_site   
   end
   
   def demonitorEngine
     engine = loadManagedEngine params
     engine.unmonitor_site
   end
end
