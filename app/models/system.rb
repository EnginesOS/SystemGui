class System

  extend Engines::Api

  def self.monitor
    {
      memory: engines_api.get_system_memory_info,
      loading: engines_api.get_system_load_info,
      old: {
        snapshot: Vmstat.snapshot,
        vm2: (sleep(1); Vmstat.memory),
        cpu: Vmstat.cpu
      }
    }
  end

  def self.info
    {
      memory: engines_api.get_system_memory_info[:total],
      cpus: Vmstat.cpu.count
    }
  end
  
  def self.restart
    engines_api.restart_system
  end
  
  def self.update
    engines_api.update_system
  end

end