class SystemEnginesUpdatesController < ApplicationController
  before_action :authenticate_user!

  def show
    if !System.engines_updating?
      result = System.update_engines
      if result.kind_of?(EnginesOSapiResult)
        if result.was_success
          System.enable_engines_updating_flag
          @system_status = System.status
        else
          redirect_to updater_system_path, alert: ( "Unable to update Engines system. " + result.result_mesg )[0,500]
        end
      else
        redirect_to updater_system_path, alert: "No result"
      end
    end
  end
  
  def progress
    if System.engines_updating?
      render text: "updating"
    else
      System.disable_engines_updating_flag
      System.check_for_needs_restart
      render text: "done"
    end
  end

end
