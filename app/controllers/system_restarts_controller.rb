class SystemRestartsController < ApplicationController
  before_action :authenticate_user!

  def show
    if !System.restarting?
      # result = System.restart
      if true #result.kind_of?(EnginesOSapiResult)
        if true #result.was_success
          System.enable_restarting_flag
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
    System.disable_restarting_flag
    render text: "done"
  end

end
