module SystemInfo

  extend Engines::Api

  def self.memory_statistics
    engines_api.get_memory_statistics
  end

  def self.system_update_status
    SystemStatus.system_update_status
  end

  def self.cpus_usage
    Vmstat.snapshot
  end

  def self.disks_usage
    Vmstat.snapshot.disks
  end

  def self.network_interfaces_usage
    Vmstat.network_interfaces.reject{ |ni| ni[:name].to_s.include?('veth') || ni[:name].to_s.include?('lo') }
  end

  def self.engines_version
    System.engines_api.version_string
  end

  def self.base_os_data
    SystemUtils.get_os_release_data
  end

  def self.logs
    100.times.map{ |a| "log data."}.join("\n")
  end

  def self.summary
    {
      # CPUs: monitor_cpu.cpus.count,
      engines_release: engines_api.get_engines_system_release
    }
  end

  def self.settings_summary
    {
      'Send system bug reports' => engines_api.is_remote_exception_logging?
    }
  end

end



# def self.monitor_data_applications_memory:
#         {
#           : application_memory_usage,
#           services: services_memory_usage,
#           totals: total_system_memory_usage,
#           statistics: memory_statistics
#         }
#   }
# end


# def self.monitor_data
#   {
#       cpu: Vmstat.snapshot,
#       disks: Vmstat.snapshot.disks,
#       network_interfaces: Vmstat.network_interfaces.reject{ |ni| ni[:name].to_s.include?('veth') || ni[:name].to_s.include?('lo') },
#       memory:
#         {
#           applications: application_memory_usage,
#           services: services_memory_usage,
#           totals: total_system_memory_usage,
#           statistics: memory_statistics
#         }
#   }
# end


# def self.monitor_cpu
#   system_vmstat[:cpu]
# end

# def self.otherstuff
  # {
    # loading: engines_api.get_system_load_info,
    # memory: engines_api.get_memory_statistics,
    # virtual_memory: Vmstat.memory,
    # disks: Vmstat.snapshot.disks,
    # network_interfaces: Vmstat.network_interfaces,
    # cpu: Vmstat.cpu,
  # }
# end

# def self.disk_usage_data
#   system_vmstat[:disks] #
# end

# def self.network_interfaces_data
#   system_vmstat[:network_interfaces]
# end

# def self.cpu_loads
  # Vmstat.snapshot.cpus
# end
