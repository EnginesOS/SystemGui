class SystemRestartMgmtsController < ApplicationController

  def show
    if @system_status[:state] != :restarting_mgmt
      result = System.restart_mgmt
      if result.kind_of?(EnginesOSapiResult)
        if result.was_success
          @system_status = System.status
          flash[:notice] = result.result_mesg
        else
          redirect_to services_control_panel_path, alert: ( "Unable to restart Engines system manager. " + result.result_mesg )[0,500]
        end
      else
        redirect_to services_control_panel_path, alert: "No result"
      end
    end
  end

  def progress
    if @system_status[:state] == :restarting_mgmt
      render text: "busy"
    else
      render text: "done"
    end
  end

end
