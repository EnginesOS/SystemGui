class SystemMonitorCharts

  def memory_statistics
    @memory_statistics ||= SystemDataCache.memory_statistics
  end

  def cpus_usage_data
    @cpus_usage_data ||= SystemInfo.cpus_usage
  end

  def disks_usage_data
    @disks_usage_data ||= SystemInfo.disks_usage
  end

  def network_interfaces_usage_data
    @network_interfaces_usage_data ||= SystemInfo.network_interfaces_usage
  end

  def application_memory_usage
    @application_memory_usage ||= memory_statistics[:containers][:applications].
      select { |keys, values| (values.is_a? Hash) && values.present? && (values[:limit].to_i > 0) }.
      sort.to_h.sort_by { |keys, values| 1.0/values[:limit].to_i }.to_h
  end

  def services_memory_usage
    @services_memory_usage ||= memory_statistics[:containers][:services].
      select{ |keys, values| (values.is_a? Hash) && values.present? && (values[:limit].to_i > 0) }.
      sort.to_h.sort_by { |keys, values| 1.0/values[:limit].to_i }.to_h
  end

  def unaccounted_memory
    @unaccounted_memory ||= (memory_statistics[:system][:total].to_i -
                              memory_statistics[:system][:active].to_i -
                              memory_statistics[:system][:buffers].to_i -
                              memory_statistics[:system][:file_cache].to_i -
                              memory_statistics[:system][:free].to_i )/1024
  end

  def total_system_memory_usage
    @total_system_memory_usage ||= {
      "Active #{memory_statistics[:system][:active].to_i/1024} MB" => memory_statistics[:system][:active].to_i/1024,
      "Buffers #{memory_statistics[:system][:buffers].to_i/1024} MB" => memory_statistics[:system][:buffers].to_i/1024,
      "File cache #{memory_statistics[:system][:file_cache].to_i/1024} MB" => memory_statistics[:system][:file_cache].to_i/1024,
      "Free #{memory_statistics[:system][:free].to_i/1024} MB" => memory_statistics[:system][:free].to_i/1024,
    }.merge(
      if unaccounted_memory > 0
        {"Other #{other} MB" => unaccounted_memory}
      else
        {}
      end
    )
  end

  def application_data_present?
    application_memory_usage.present?
  end

  def system_cpu_usage_bar_chart
    cpu_data = cpus_usage_data.cpus
    cpus_count = cpu_data.count
    labels = {}
    cpus_count.times.each_with_index{ |label, i| labels[i] = "CPU #{i}" }

    @g = Gruff::SideStackedBar.new("800x#{50*cpus_count+ 135}")
    @g.labels = labels

    users_cpus_usage = cpu_data.map(&:user)
    system_cpus_usage = cpu_data.map(&:system)
    nice_cpus_usage = cpu_data.map(&:nice)
    idle_cpus_usage = cpu_data.map(&:idle)

    total_cpu_usage = []

    cpus_count.times.each do |i|
      total_cpu_usage << users_cpus_usage[i] + system_cpus_usage[i] + nice_cpus_usage[i] + idle_cpus_usage[i]
    end

    users_cpus_usage = users_cpus_usage.map.with_index{ |d, i| d.to_i*1000/total_cpu_usage[i].to_i }
    system_cpus_usage = system_cpus_usage.map.with_index{ |d, i| d.to_i*1000/total_cpu_usage[i].to_i }
    nice_cpus_usage = nice_cpus_usage.map.with_index{ |d, i| d.to_i*1000/total_cpu_usage[i].to_i }
    idle_cpus_usage = idle_cpus_usage.map.with_index{ |d, i| d.to_i*1000/total_cpu_usage[i].to_i }

    @g.data "User", users_cpus_usage
    @g.data "System", system_cpus_usage
    @g.data "Nice", nice_cpus_usage
    @g.data "Idle", idle_cpus_usage
    @g.legend_font_size = 18
    @g.title_font_size = 18
    @g.marker_font_size = 16
    @g.hide_line_numbers = true
    @g.theme = {
      :colors => [
        '#3071A9',  # blue
        '#F0AD4E',  # orange
        '#999999',  # grey
        '#44AA44',  # green
      ],
      :marker_color => 'white',
      :font_color => 'black',
      :background_colors => 'white'
    }
    @g.to_blob
  end

  def system_cpu_usage_averages_bar_chart
    @g = Gruff::Bar.new("600x300")
    @g.title = 'Processes waiting to run'
    @g.data "One min #{cpus_usage_data.load_average.one_minute}", cpus_usage_data.load_average.one_minute
    @g.data "Five mins #{cpus_usage_data.load_average.five_minutes}", cpus_usage_data.load_average.five_minutes
    @g.data "Fifteen mins #{cpus_usage_data.load_average.fifteen_minutes}", cpus_usage_data.load_average.fifteen_minutes
    @g.minimum_value = 0
    @g.legend_font_size = 24
    @g.title_font_size = 24
    @g.marker_font_size = 16
    @g.hide_line_numbers = true
    @g.theme = {
      :colors => [
        '#3071A9',  # blue
        '#F0AD4E',  # orange
        '#999999',  # grey
        '#44AA44',  # green
      ],
      :marker_color => 'white',
      :font_color => 'black',
      :background_colors => 'white'
    }
    @g.to_blob
  end

  def disk_usage_bar_chart
    disk_data = disks_usage_data

    available_disk_data = disk_data.map{ |d| d.available_blocks*100/d.total_blocks}
    used_disk_data = available_disk_data.map{ |d| 100 - d}

    labels = {}
    disk_data.each_with_index.map{ |d, i| labels[i] = "#{d.type} #{d.mount}\n#{d.total_blocks}" }

    disk_count = disk_data.count

    @g = Gruff::SideStackedBar.new("800x#{50*disk_count+ 155}")
    @g.labels = labels
    @g.title = 'Disk mounts (blocks)'

    @g.data "Used", used_disk_data
    @g.data "Available", available_disk_data
    @g.legend_font_size = 18
    @g.title_font_size = 18
    @g.marker_font_size = 16
    @g.hide_line_numbers = true
    @g.theme = {
      :colors => [
        '#3071A9',  # blue
        '#F0AD4E',  # orange
        '#999999',  # grey
        '#44AA44',  # green
      ],
      :marker_color => 'white',
      :font_color => 'black',
      :background_colors => 'white'
    }
    @g.to_blob
  end

  def network_usage_bar_chart
    network_data = network_interfaces_usage_data
    network_count = network_data.count
    @g = Gruff::SideBar.new("800x#{50*network_count+ 155}")

    in_data = network_data.map{ |n| n.in_bytes }
    out_data = network_data.map{ |n| n.out_bytes }

    max_value = [ in_data.max, out_data.max ].max
    max_value_length = max_value.to_s.length.to_i-1
    max_value_order_of_magnitude = max_value_length/3
    network_traffic_scale = 1000**max_value_order_of_magnitude
    unit = {0=>"",1=>"k",2=>"M",3=>"G",4=>"T",5=>"P",6=>"E",7=>"Z",8=>"Y"}
    @g.title = 'Network traffic (' + unit[max_value_order_of_magnitude].to_s + 'B)'

    in_data = network_data.map{ |n| n.in_bytes/network_traffic_scale }
    out_data = network_data.map{ |n| n.out_bytes/network_traffic_scale }

    labels = {}
    network_data.each_with_index.map{ |n, i| labels[i] = n.name.to_s }
    @g.labels = labels

    @g.data "In", in_data
    @g.data "Out", out_data

    @g.legend_font_size = 18
    @g.title_font_size = 18
    @g.marker_font_size = 16
    @g.theme = {
      :colors => [
        '#3071A9',  # blue
        '#F0AD4E',  # orange
        '#999999',  # grey
        '#44AA44',  # green
      ],
      :marker_color => 'white',
      :font_color => 'black',
      :background_colors => 'white'
    }
    @g.to_blob
  end

  def total_system_memory_usage_pie_chart
    @g = Gruff::Pie.new('800x500')
    total_system_memory_usage.each { |k,v| @g.data k, v }
    @g.label_formatter = Proc.new { |data_row| data_row[0] }
    @g.hide_labels_less_than = 5
    @g.hide_legend = false
    @g.title = "System #{memory_statistics[:system][:total].to_i/1024} MB"
    @g.text_offset_percentage = 0
    render_pie_chart
  end

  def total_container_memory_usage_pie_chart
    @g = Gruff::Pie.new('800x400')
    application_totals = memory_statistics[:containers][:totals][:applications][:allocated].to_i/1048576
    services_totals = memory_statistics[:containers][:totals][:services][:allocated].to_i/1048576
    { "Applications #{application_totals} MB" => application_totals, "Services #{services_totals} MB" => services_totals }.each { |k,v| @g.data k, v }
    @g.label_formatter = Proc.new { |data_row| data_row[0] }
    @g.hide_labels_less_than = 5
    @g.hide_legend = true
    @g.title = "Containers #{application_totals + services_totals} MB"
    @g.text_offset_percentage = 0
    render_pie_chart
  end

  def total_container_memory_usage_bar_chart
    @g = Gruff::SideStackedBar.new('800x235')

    application_totals = memory_statistics[:containers][:totals][:applications]
    if application_totals[:allocated] > 0
      applications_currently_in_use  = ( application_totals[:in_use].to_f/application_totals[:allocated].to_f*100 ).to_i
      applications_peak_usage = (( application_totals[:peak_sum].to_f - application_totals[:in_use].to_f)/application_totals[:allocated].to_f*100 ).to_i
      applications_headroom = (( application_totals[:allocated].to_f - application_totals[:peak_sum].to_f)/application_totals[:allocated].to_f*100 ).to_i
    else
      applications_currently_in_use  = 0
      applications_peak_usage = 0
      applications_headroom = 0
    end

    services_totals = memory_statistics[:containers][:totals][:services]
    if services_totals[:allocated] > 0
      services_currently_in_use  = ( services_totals[:in_use].to_f/services_totals[:allocated].to_f*100 ).to_i
      services_peak_usage = (( services_totals[:peak_sum].to_f - services_totals[:in_use].to_f) /services_totals[:allocated].to_f*100 ).to_i
      services_headroom = (( services_totals[:allocated].to_f - services_totals[:peak_sum].to_f)/services_totals[:allocated].to_f*100 ).to_i
    else
      services_currently_in_use  = 0
      services_peak_usage = 0
      services_headroom = 0
    end

    {
      :"Current" => [ applications_currently_in_use, services_currently_in_use ],
      :"Peak" => [ applications_peak_usage, services_peak_usage ],
      :"Headroom" => [ applications_headroom, services_headroom ]
    }.each { |k,v| @g.data k, v }

    @g.labels = { 0 => "Applications #{application_totals[:allocated].to_i/1048576} MB", 1 => "Services #{services_totals[:allocated].to_i/1048576} MB" };

    render_memory_usage_bar_chart
  end

  def total_applications_memory_usage_pie_chart
    @g = Gruff::Pie.new('800x400')
    (@g.data '', 0) if application_memory_usage.empty?
    application_memory_usage.each { |key, value| @g.data "#{key} #{value[:limit].to_i/1048576} MB", value[:limit].to_i }
    @g.label_formatter = Proc.new { |data_row| data_row[0] }
    @g.hide_labels_less_than = 5
    @g.hide_legend = true
    @g.title = "Applications #{memory_statistics[:containers][:totals][:applications][:allocated].to_i/1048576} MB"
    @g.text_offset_percentage = 0
    render_pie_chart
  end

  def applications_memory_usage_bar_chart
    application_names = application_memory_usage.map { |key, value| "#{key} #{value[:limit].to_i/1048576} MB" }
    application_count = application_names.count
    labels = {}
    application_names.each_with_index{ |label, i| labels[i] = label.to_s }

    @g = Gruff::SideStackedBar.new("800x#{50*application_count+ 135}")
    @g.labels = labels

    application_usage_values = application_memory_usage.values
    application_in_use_memory_values = application_usage_values.map{ |values| values[:current].to_f / values[:limit].to_f * 100 }
    application_peak_memory_values = application_usage_values.map{ |values| ( values[:maximum].to_f - values[:current].to_f ) / values[:limit].to_f * 100 }
    application_headroom_values = application_usage_values.map{ |values| ( values[:limit].to_f - values[:maximum].to_f ) / values[:limit].to_f * 100 }

    @g.data "Current", application_in_use_memory_values
    @g.data "Peak", application_peak_memory_values
    @g.data "Headroom", application_headroom_values

    render_memory_usage_bar_chart
  end

  def total_services_memory_usage_pie_chart
    @g = Gruff::Pie.new('800x400')
    services_memory_usage.each { |key, value| @g.data "#{key} #{value[:limit].to_i/1048576} MB", value[:limit].to_i }
    @g.hide_labels_less_than = 5
    @g.label_formatter = Proc.new { |data_row| data_row[0] }
    @g.hide_legend = true
    @g.title = "Services #{memory_statistics[:containers][:totals][:services][:allocated].to_i/1048576} MB"
    @g.text_offset_percentage = 0
    render_pie_chart
  end

  def services_memory_usage_bar_chart
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

    render_memory_usage_bar_chart
  end

  def render_memory_usage_bar_chart
    @g.title_font_size = 18
    @g.legend_font_size = 18
    @g.marker_font_size = 16
    @g.hide_line_numbers = true
    @g.theme = {
      :colors => [
        '#3071A9',  # blue
        '#F0AD4E',  # orange
        '#44AA44',  # green
      ],
      :marker_color => 'white',
      :font_color => 'black',
      :background_colors => 'white'
    }
    @g.to_blob
  end

  def render_pie_chart
    @g.title_font_size = 18
    @g.legend_font_size = 18
    @g.marker_font_size = 16
    @g.hide_line_numbers = true
    @g.theme = {
      :colors => [
        '#F0AD4E',  # orange
        '#3071A9',  # blue
        '#8A6EAF',  # purple
        '#44AA44',  # green
        '#EFDA43',  # yellow
        '#EE9494',  # red
        '#999999',  #grey
        "#A630AC", "#3650A0", "#1F1D6D", "#80C837", "#ACD62A", "#20B2AA",
        "#229F6E", "#C11C17", "#60B6CA", "#E0E61A", "#DE5003", "#4CA82B",
        "#EFCE10", "#E27A1D", "#7F91C3", "#434187", "#228B22", "#502E72", #loads of other colors for the skinny slices
        "#575597", "#3B256D", "#A63570", "#E6AA19", "#A670B8", "#93BDE7",
        "#6F6DA7", "#A6358C", "#A2395B"],
      :marker_color => 'white',
      :font_color => 'black',
      :background_colors => 'white'
    }
    @g.to_blob
  end

end
