module SystemInfo
  
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

  def self.memory_statistics
    engines_api.get_memory_statistics
  end
  
  def self.total_memory
    memory_statistics[]
  end
  
  def self.cpus
    Vmstat.cpu.count.to_s
  end
  
  def self.memory_usage
    {
      Used: memory_statistics[:system][:total].to_i - memory_statistics[:system][:free].to_i,
      Free: memory_statistics[:system][:free].to_i
    }
  end
  
  def self.memory_usage_pie_chart
    g = Gruff::Pie.new('600x400')
    memory_usage.each { |k,v| g.data k, v }
    g.theme = {
      :colors => [
        '#F0AD4E',  # yellow
        '#3071A9',  # blue
        '#72AE6E',  # green
        '#D1695E',  # red
        '#8A6EAF',  # purple
        '#EFAA43',  # orange
        'white'
      ],
      :marker_color => 'white',
      :font_color => 'black',
      :background_colors => 'white'
    }
    g.to_blob
  end
  
end