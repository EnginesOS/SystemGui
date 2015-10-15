class SystemsController < ApplicationController

  def show
    @system_info = SystemInfo
  end
  
  def memory_usage_pie_chart
    send_data(SystemInfo.memory_usage_pie_chart, :filename => "memory_usage_pie_chart.png", :type => 'image/png')
  end

  def monitor
    @system_monitor = SystemInfo.monitor
  end

  def updater
  end
  
  def restart
  end

end
