class SystemEnginesUpdatesController < ApplicationController
  before_action :authenticate_user!

  def show
    if !System.engines_updating?
      result = System.update_engines
      if result.kind_of?(EnginesOSapiResult)
        if result.was_success
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
      
p :bussssssssssssssssssssssssy
      
      render text: "busy"
    else

p :donnnnnnnnnnnnnnnnnnnnnnnne

      render text: "done"
    end
  end

end
