class SystemBaseUpdatesController < ApplicationController
  before_action :authenticate_user!

  def show
    if !System.base_system_updating?
      result = System.update_base
      if result.kind_of?(EnginesOSapiResult)
        if result.was_success
          System.enable_base_system_updating_flag
          @system_status = System.status
        else
          redirect_to system_update_path, alert: ( "Unable to update base system. " + result.result_mesg )[0,500]
        end
      else
        redirect_to system_update_path, alert: "No result"
      end
    end
  end
  
  def progress
    if System.base_system_updating?
      render text: "updating"
    else
      System.disable_base_system_updating_flag
      System.check_for_needs_restart
      render text: "done"
    end
  end

end
