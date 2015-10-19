class ChartsController < ApplicationController

  def total_system_memory_usage
    send_data(SystemInfo.total_system_memory_usage_pie_chart, :filename => "memory_usage_chart.png", :type => 'image/png')
  end

  def total_container_memory_usage
    send_data(SystemInfo.total_container_memory_usage_bar_chart, :filename => "memory_usage_chart.png", :type => 'image/png')
  end

  def applications_memory_usage
    send_data(SystemInfo.applications_memory_usage_bar_chart, :filename => "memory_usage_chart.png", :type => 'image/png')
  end

end
