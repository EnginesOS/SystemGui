
require "/opt/engos/lib/ruby/ManagedContainer.rb"
require "/opt/engos/lib/ruby/SysConfig.rb"
require "/opt/engos/lib/ruby/ManagedEngine.rb"
require "/opt/engos/lib/ruby/ManagedService.rb"
require "/opt/engos/lib/ruby/NginxService.rb"
require "/opt/engos/lib/ruby/NagiosService.rb"

class EnginesOSapi
  def initialize()
      
  end
    
  def EnginesOS_api.getManagedEngines
    return ManagedEngine.getManagedEngines()
  end
  
  def EnginesOS_api.loadManagedEngine
    return ManagedEngine.load(params)
  end
end
