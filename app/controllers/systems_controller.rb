class SystemsController < ApplicationController

  def show
    @system_info = SystemInfo
  end
  
  def monitor
    @system_monitor = SystemInfo.monitor
  end

  def updater
  end
  
  def restart
  end

end
