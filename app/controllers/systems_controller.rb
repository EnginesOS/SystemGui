class SystemsController < ApplicationController
  before_action :authenticate_user!

  def monitor
    @system_monitor = System.monitor
  end

  def show
    @system_info = System.info
  end
  
  def restart
    result = System.restart
    if result.kind_of?(EnginesOSapiResult)
      if result.was_success
        redirect_to restarting_system_path
      else
        redirect_to control_panel_path, alert: ( "Unable to restart system. " + result.result_mesg )[0,500]
      end
    else
      redirect_to control_panel_path, alert: "No result"
    end
  end
  
  def restarting
  end

end
