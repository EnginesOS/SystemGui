module SystemInfo
  
  extend Engines::Api
  
  def self.monitor_cpu
    Vmstat.snapshot
  end
  
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

  def self.disk_usage_data
    Vmstat.snapshot.disks
  end

  def self.network_interfaces_data
    Vmstat.network_interfaces.reject{ |ni| ni[:name].to_s.include?('veth') || ni[:name].to_s.include?('lo') }
  end

  # def self.cpu_loads
    # Vmstat.snapshot.cpus
  # end

  def self.memory_statistics
    engines_api.get_memory_statistics
  end
  
  # def self.cpus
    # Vmstat.cpu.count.to_s
  # end
#   
  def self.application_memory_usage
    memory_statistics[:containers][:applications].
      select { |keys, values| (values.is_a? Hash) && values.present? && (values[:limit].to_i > 0) }.
      sort.to_h.sort_by { |keys, values| 1.0/values[:limit].to_i }.to_h
  end

  def self.services_memory_usage
    memory_statistics[:containers][:services].
      select{ |keys, values| (values.is_a? Hash) && values.present? && (values[:limit].to_i > 0) }.
      sort.to_h.sort_by { |keys, values| 1.0/values[:limit].to_i }.to_h
  end

  def self.total_system_memory_usage
    other = ( memory_statistics[:system][:total].to_i - 
                memory_statistics[:system][:active].to_i -
                memory_statistics[:system][:buffers].to_i -
                memory_statistics[:system][:file_cache].to_i -
                memory_statistics[:system][:free].to_i )/1024
    {
      "Active #{memory_statistics[:system][:active].to_i/1024} MB" => memory_statistics[:system][:active].to_i/1024,
      "Buffers #{memory_statistics[:system][:buffers].to_i/1024} MB" => memory_statistics[:system][:buffers].to_i/1024,
      "File cache #{memory_statistics[:system][:file_cache].to_i/1024} MB" => memory_statistics[:system][:file_cache].to_i/1024,
      "Free #{memory_statistics[:system][:free].to_i/1024} MB" => memory_statistics[:system][:free].to_i/1024,
    }.merge(
      if other > 0
        {"Other #{other} MB" => other}
      else
        {}
      end      
    )
  end
  
  def self.base_os_data
    SystemUtils.get_os_release_data
  end
  
  def self.logs
    100.times.map{ |a| "James to privide method for log data."}.join("\n")
  end
  
  def self.summary
    {
      CPUs: monitor_cpu.cpus.count,
      'Engines system release' => engines_api.get_engines_system_release
    }
  end
  
  
  

end