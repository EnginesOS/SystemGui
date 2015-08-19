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
  
  def self.update_base
    engines_api.update_system
  end

  def self.update_engines
    engines_api.update_engines_system_software 
  end
  
  def self.status
    if restarting?
      {state: :restarting, message: "Rebooting", message_class: :warning}
    elsif engines_updating?
      {state: :engines_updating, message: "Updating", message_class: :warning}
    elsif base_system_updating?
      {state: :base_updating, message: "Updating", message_class: :warning}
    elsif installing?
      {state: :installing, message: "Installing", message_class: :warning}
    elsif needs_restart?
      {state: :needs_restart ,message: "Needs reboot", message_class: :danger, button_url: "/system/restart"}
    else
      {state: :ok, message: "OK", message_class: :ok}
    end
  end
  
  def self.enable_restarting_flag;            $restarting = "1"; end
  def self.disable_restarting_flag;           $restarting = "0"; end
  def self.restarting?;                       $restarting == "1"; end

  def self.enable_engines_updating_flag;      $engines_updating = "1"; end
  def self.disable_engines_updating_flag;     $engines_updating = "0"; end
  def self.engines_updating?;                 $engines_updating == "1" && engines_api.is_engines_system_updating?; end

  def self.enable_base_system_updating_flag;  $base_updating = "1"; end
  def self.disable_base_system_updating_flag; $base_updating = "0"; end
  def self.base_system_updating?;             $base_updating == "1" && engines_api.is_base_system_updating?; end

  def self.enable_installing_flag;            $installing = "1"; end
  def self.disable_installing_flag;           $installing = "0"; end
  def self.installing?;                       $installing == "1";  end
  def self.set_installing_params(params);     $installing_params = params; end
  def self.installing_params;                 $installing_params; end

  def self.check_for_needs_restart;           engines_api.needs_reboot? ? $needs_restart = "1" : $needs_restart = "0"; end
  def self.needs_restart?;                    $needs_restart == "1"; end

  def self.enable_no_default_domain_flag;     $no_default_domain = "1"; end
  def self.disable_no_default_domain_flag;    $no_default_domain = "0"; end
  def self.no_default_domain?;                $no_default_domain == "1";  end



end