class SystemsController < ApplicationController

  def show
    @system_info = System.info
  end

  def monitor
    @system_monitor = System.monitor
  end

  def updater
  end
  
  def restart
  end

end
