class SystemRestartRegistriesController < ApplicationController

  def show
    if @system_status[:state] != :restarting_registry
      result = System.restart_registry
      if result.kind_of?(EnginesOSapiResult)
        if result.was_success
          @system_status = System.status
        else
          redirect_to updater_system_path, alert: ( "Unable to update Engines system. " + result.result_mesg )[0,500]
        end
      else
        redirect_to services_control_panel_path, alert: "No result"
      end
    end
  end
  
  def progress
    if @system_status[:state] == :restarting_registry
      render text: "busy"
    else
      render text: "done"
    end
  end

end