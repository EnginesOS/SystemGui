class SystemRestartsController < ApplicationController

  def show
    if @system_status[:state] != :restarting
      result = System.restart
      if result.kind_of?(EnginesOSapiResult)
        if result.was_success
          @system_status = System.status
        else
          redirect_to control_panel_path, notice: ( "Unable to restart system. " + result.result_mesg )[0..500]
        end
      else
        redirect_to control_panel_path, warning: "No result"
      end
    end
  end

  def progress
    if @system_status[:state] == :restarting
      render text: "busy"
    else
      render text: "done"
    end
  end

end
