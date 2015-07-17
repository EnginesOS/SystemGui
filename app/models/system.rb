class System

  extend Engines::Api

  def self.system_info
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
  
  def self.reboot
    engines_api.reboot_system
  end
  
  def self.update
    engines_api.system_update
  end

end