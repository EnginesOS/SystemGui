class SystemRestartsController < ApplicationController
  before_action :authenticate_user!

  def show
  end
  
  def restart
    result = System.restart
    if result.kind_of?(EnginesOSapiResult)
      if result.was_success
        redirect_to restarting_system_restart_path
      else
        redirect_to control_panel_path, notice: ( "Unable to restart system. " + result.result_mesg )[0..500]
      end
    else
      redirect_to control_panel_path, warning: "No result"
    end
  end
  
  def restarting
  end

end
