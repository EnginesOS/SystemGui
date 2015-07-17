class SystemsController < ApplicationController
  before_action :authenticate_user!

  def show
    @system_info = System.system_info
  end
  
  def restart
    # result = System.restart
    # if result.kind_of?(EnginesOSapiResult)
      # if result.was_success
        redirect_to restarting_system_path
      # else
        # redirect_to control_panel_path, alert: ( "Unable to restart system. " + result.result_mesg )[0,500]
      # end
    # else
      # redirect_to control_panel_path, alert: "No result"
    # end
  end
  
  def restarting
  end

  def engines_update
    result = System.update
    if result.kind_of?(EnginesOSapiResult)
      if result.was_success
        alert = "Updating..."
      else
        alert = ( "Unable to update system. " + result.result_mesg )[0,500]
      end
    else
      alert = "No result"
    end
    redirect_to control_panel_path, alert: alert
  end

end
