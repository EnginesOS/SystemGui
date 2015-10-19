module SystemInfo
  
  extend Engines::Api
  require "matrix"
  
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
  
  def self.total_system_memory_usage
    {
      # Used: memory_statistics[:system][:total].to_i - memory_statistics[:system][:free].to_i,
      "Active #{memory_statistics[:system][:active].to_i/1024} Mb" => memory_statistics[:system][:active].to_i,
      "Inactive #{memory_statistics[:system][:inactive].to_i/1024} Mb" => memory_statistics[:system][:inactive].to_i,
      "Buffers #{memory_statistics[:system][:buffers].to_i/1024} Mb" => memory_statistics[:system][:buffers].to_i,
      "File cache #{memory_statistics[:system][:file_cache].to_i/1024} Mb" => memory_statistics[:system][:file_cache].to_i,
      "Free #{memory_statistics[:system][:free].to_i/1024} Mb" => memory_statistics[:system][:free].to_i
    }
  end


  def self.applications_memory_usage_bar_chart
    application_memory_usage = memory_statistics[:containers][:applications]
    application_names = application_memory_usage.keys
    application_count = application_names.count

    g = Gruff::SideStackedBar.new("600x#{50*application_count+ 100}")
    
    application_names = application_memory_usage.keys
    labels = {}
    application_names.each_with_index{ |label, i| p :label; p label; p i; labels[i] = label.to_s }
    g.labels = labels

    application_usage_values = application_memory_usage.values
    application_in_use_memory_values = Matrix[application_usage_values.map{ |values| values[:current].to_i/1048576 }]
    application_peak_memory_values = Matrix[application_usage_values.map{ |values| values[:maximum].to_i/1048576 }] - application_in_use_memory_values
    application_headroom_values = Matrix[application_usage_values.map{ |values| values[:limit].to_i/1048576 }] - application_peak_memory_values
    
    
p :aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
p application_in_use_memory_values.to_a.first
p application_peak_memory_values.to_a.first
p application_headroom_values.to_a.first
    
    
    g.data "Currently in use", application_in_use_memory_values.to_a.first
    g.data "Peak use", application_peak_memory_values.to_a.first
    g.data "Headroom", application_headroom_values.to_a.first


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
  
  def self.total_container_memory_usage_bar_chart
    g = Gruff::StackedBar.new('600x400')

    application_totals = memory_statistics[:containers][:totals][:applications]
    applications_currently_in_use  = application_totals[:in_use].to_i/1048576
    applications_peak_usage = ( application_totals[:peak_sum].to_i - application_totals[:in_use].to_i)/1048576
    applications_headroom = ( application_totals[:allocated].to_i - application_totals[:peak_sum].to_i)/1048576

    services_totals = memory_statistics[:containers][:totals][:services]
    services_currently_in_use  = services_totals[:in_use].to_i/1048576
    services_peak_usage = ( services_totals[:peak_sum].to_i - services_totals[:in_use].to_i) /1048576
    services_headroom = ( services_totals[:allocated].to_i - services_totals[:peak_sum].to_i)/1048576

    {
      :"Currently in use" => [ applications_currently_in_use, services_currently_in_use ],
      :"Peak usage" => [ applications_peak_usage, services_peak_usage ],
      Headroom: [ applications_headroom, services_headroom ]
    }.each { |k,v| g.data k, v }
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
    
    g.labels = { 0 => "Applications #{application_totals[:allocated].to_i/1048576} Mb", 1 => "Services #{services_totals[:allocated].to_i/1048576} Mb" };
    
    g.to_blob
  end

  def self.total_system_memory_usage_pie_chart
    g = Gruff::Pie.new('600x400')
    total_system_memory_usage.each { |k,v| g.data k, v }
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