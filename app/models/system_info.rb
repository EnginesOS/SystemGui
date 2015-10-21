module SystemInfo
  
  extend Engines::Api
  # require "matrix"
  
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
    other = ( memory_statistics[:system][:total].to_i - 
                memory_statistics[:system][:active].to_i -
                memory_statistics[:system][:buffers].to_i -
                memory_statistics[:system][:file_cache].to_i -
                memory_statistics[:system][:free].to_i )/1024
    {
      # Used: memory_statistics[:system][:total].to_i - memory_statistics[:system][:free].to_i,
      "Active #{memory_statistics[:system][:active].to_i/1024} MB" => memory_statistics[:system][:active].to_i/1024,
      "Buffers #{memory_statistics[:system][:buffers].to_i/1024} MB" => memory_statistics[:system][:buffers].to_i/1024,
      "File cache #{memory_statistics[:system][:file_cache].to_i/1024} MB" => memory_statistics[:system][:file_cache].to_i/1024,
      "Free #{memory_statistics[:system][:free].to_i/1024} MB" => memory_statistics[:system][:free].to_i/1024,
      "Other #{other} MB" => other
    }
  end

  def self.total_system_memory_usage_pie_chart
    @g = Gruff::Pie.new('800x400')
    total_system_memory_usage.each { |k,v| @g.data k, v }
    @g.label_formatter = Proc.new { |data_row| data_row[0] }
    @g.hide_legend = true
    @g.title = "System #{memory_statistics[:system][:total].to_i/1024} MB"
    @g.text_offset_percentage = 0
    render_pie_chart
  end
    
  def self.total_container_memory_usage_pie_chart
    @g = Gruff::Pie.new('800x400')
    application_totals = memory_statistics[:containers][:totals][:applications][:allocated].to_i/1048576
    services_totals = memory_statistics[:containers][:totals][:services][:allocated].to_i/1048576
    { "Applications #{application_totals} MB" => application_totals, "Services #{services_totals} MB" => services_totals }.each { |k,v| @g.data k, v }
    @g.label_formatter = Proc.new { |data_row| data_row[0] }
    @g.hide_legend = true
    @g.title = "Containers #{application_totals + services_totals} MB"
    @g.text_offset_percentage = 0
    render_pie_chart
  end
    
  def self.total_container_memory_usage_bar_chart
    @g = Gruff::SideStackedBar.new('800x235')

    application_totals = memory_statistics[:containers][:totals][:applications]
    applications_currently_in_use  = application_totals[:in_use].to_f/application_totals[:allocated].to_f*100
    applications_peak_usage = ( application_totals[:peak_sum].to_f - application_totals[:in_use].to_f)/application_totals[:allocated].to_f*100
    applications_headroom = ( application_totals[:allocated].to_f - application_totals[:peak_sum].to_f)/application_totals[:allocated].to_f*100

    services_totals = memory_statistics[:containers][:totals][:services]
    services_currently_in_use  = services_totals[:in_use].to_f/services_totals[:allocated].to_f*100
    services_peak_usage = ( services_totals[:peak_sum].to_f - services_totals[:in_use].to_f) /services_totals[:allocated].to_f*100
    services_headroom = ( services_totals[:allocated].to_f - services_totals[:peak_sum].to_f)/services_totals[:allocated].to_f*100

    {
      :"Current" => [ applications_currently_in_use, services_currently_in_use ],
      :"Peak" => [ applications_peak_usage, services_peak_usage ],
      :"Headroom" => [ applications_headroom, services_headroom ]
    }.each { |k,v| @g.data k, v }

    @g.labels = { 0 => "Applications #{application_totals[:allocated].to_i/1048576} MB", 1 => "Services #{services_totals[:allocated].to_i/1048576} MB" };
    
    render_bar_chart
  end

  def self.application_memory_usage
    memory_statistics[:containers][:applications].
      select { |keys, values| (values.is_a? Hash) && values.present? && (values[:limit].to_i > 0) }.
      sort.to_h.sort_by { |keys, values| 1.0/values[:limit].to_i }.to_h
  end

  def self.total_applications_memory_usage_pie_chart
    @g = Gruff::Pie.new('800x400')
    application_memory_usage.each { |key, value| @g.data "#{key} #{value[:limit].to_i/1048576} MB", value[:limit].to_i }
    @g.label_formatter = Proc.new { |data_row| data_row[0] }
    @g.hide_legend = true
    @g.title = "Applications #{memory_statistics[:containers][:totals][:applications][:allocated].to_i/1048576} MB"
    @g.text_offset_percentage = 0
    render_pie_chart
  end
    
  def self.applications_memory_usage_bar_chart
    application_names = application_memory_usage.map { |key, value| "#{key} #{value[:limit].to_i/1048576} MB" }
    application_count = application_names.count
    labels = {}
    application_names.each_with_index{ |label, i| p :label; p label; p i; labels[i] = label.to_s }

    @g = Gruff::SideStackedBar.new("800x#{50*application_count+ 135}")
    @g.labels = labels

    application_usage_values = application_memory_usage.values
    application_in_use_memory_values = application_usage_values.map{ |values| values[:current].to_f / values[:limit].to_f * 100 }
    application_peak_memory_values = application_usage_values.map{ |values| ( values[:maximum].to_f - values[:current].to_f ) / values[:limit].to_f * 100 }
    application_headroom_values = application_usage_values.map{ |values| ( values[:limit].to_f - values[:maximum].to_f ) / values[:limit].to_f * 100 }
    @g.data "Current", application_in_use_memory_values
    @g.data "Peak", application_peak_memory_values
    @g.data "Headroom", application_headroom_values
    
    render_bar_chart
  end
  
  def self.services_memory_usage
    memory_statistics[:containers][:services].
      select{ |keys, values| (values.is_a? Hash) && values.present? && (values[:limit].to_i > 0) }.
      sort.to_h.sort_by { |keys, values| 1.0/values[:limit].to_i }.to_h
  end

  def self.total_services_memory_usage_pie_chart
    @g = Gruff::Pie.new('800x400')
    services_memory_usage.each { |key, value| @g.data "#{key}", value[:limit].to_i }
    @g.hide_labels_less_than = 5
    @g.label_formatter = Proc.new { |data_row| data_row[0] }
    @g.hide_legend = true
    @g.title = "Services #{memory_statistics[:containers][:totals][:applications][:allocated].to_i/1048576} MB"
    @g.text_offset_percentage = 0
    render_pie_chart
  end
    
  def self.services_memory_usage_bar_chart
    services_names = services_memory_usage.map { |key, value| "#{key} #{value[:limit].to_i/1048576} MB" }
    services_count = services_names.count
    labels = {}
    services_names.each_with_index{ |label, i| labels[i] = label.to_s }

    @g = Gruff::SideStackedBar.new("800x#{50*services_count+ 135}")
    @g.labels = labels

    services_usage_values = services_memory_usage.values
    services_in_use_memory_values = services_usage_values.map{ |values| values[:current].to_f / values[:limit].to_f * 100 }
    services_peak_memory_values = services_usage_values.map{ |values| ( values[:maximum].to_f - values[:current].to_f ) / values[:limit].to_f * 100 }
    services_headroom_values = services_usage_values.map{ |values| ( values[:limit].to_f - values[:maximum].to_f ) / values[:limit].to_f * 100 }
    @g.data "Current", services_in_use_memory_values
    @g.data "Peak", services_peak_memory_values
    @g.data "Headroom", services_headroom_values

    render_bar_chart
  end
  
  def self.render_bar_chart
    @g.title_font_size = 18
    @g.legend_font_size = 18
    @g.marker_font_size = 16
    @g.hide_line_numbers = true
    @g.theme = {
      :colors => [
        '#3071A9',  # blue
        '#EE4444',  # red
        '#F0AD4E',  # orange
      ],
      :marker_color => 'white',
      :font_color => 'black',
      :background_colors => 'white'
    }
    @g.to_blob
  end

  def self.render_pie_chart
    @g.title_font_size = 18
    @g.legend_font_size = 18
    @g.marker_font_size = 16
    @g.hide_line_numbers = true
    @g.theme = {
      :colors => [
        '#F0AD4E',  # orange
        '#3071A9',  # blue
        '#44AA44',  # green
        '#8A6EAF',  # purple
        '#EFDA43',  # yellow
        '#EE4444',  # red
        'grey'
      ],
      :marker_color => 'white',
      :font_color => 'black',
      :background_colors => 'white'
    }
    @g.to_blob
  end

end