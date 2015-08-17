class SystemsController < ApplicationController
  before_action :authenticate_user!

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
