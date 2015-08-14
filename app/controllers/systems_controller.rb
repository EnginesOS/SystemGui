class SystemsController < ApplicationController
  before_action :authenticate_user!

  def monitor
    @system_monitor = System.monitor
  end

  def show
    @system_info = System.info
  end

end
