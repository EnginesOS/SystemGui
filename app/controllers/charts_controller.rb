class ChartsController < ApplicationController
  
  def system_cpu_usage
    send_data(SystemInfoCharts.system_cpu_usage_bar_chart, :filename => "engines_system_chart.png", :type => 'image/png')
  end
    
  def system_cpu_usage_averages
    send_data(SystemInfoCharts.system_cpu_usage_averages_bar_chart, :filename => "engines_system_chart.png", :type => 'image/png')
  end

  def total_system_memory_usage
    send_data(SystemInfoCharts.total_system_memory_usage_pie_chart, :filename => "engines_system_chart.png", :type => 'image/png')
  end

  def total_container_memory_usage
    send_data(SystemInfoCharts.total_container_memory_usage_pie_chart, :filename => "engines_system_chart.png", :type => 'image/png')
  end

  def container_memory_usage
    send_data(SystemInfoCharts.total_container_memory_usage_bar_chart, :filename => "engines_system_chart.png", :type => 'image/png')
  end

  def total_applications_memory_usage
    send_data(SystemInfoCharts.total_applications_memory_usage_pie_chart, :filename => "engines_system_chart.png", :type => 'image/png')
  end

  def applications_memory_usage
    send_data(SystemInfoCharts.applications_memory_usage_bar_chart, :filename => "engines_system_chart.png", :type => 'image/png')
  end

  def total_services_memory_usage
    send_data(SystemInfoCharts.total_services_memory_usage_pie_chart, :filename => "engines_system_chart.png", :type => 'image/png')
  end

  def services_memory_usage
    send_data(SystemInfoCharts.services_memory_usage_bar_chart, :filename => "engines_system_chart.png", :type => 'image/png')
  end

  def disk_usage
    send_data(SystemInfoCharts.disk_usage_bar_chart, :filename => "engines_system_chart.png", :type => 'image/png')
  end

  def network_usage
    send_data(SystemInfoCharts.network_usage_bar_chart, :filename => "engines_system_chart.png", :type => 'image/png')
  end

end
