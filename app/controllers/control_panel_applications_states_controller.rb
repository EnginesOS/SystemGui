class ControlPanelApplicationsStatesController < ApplicationController

  prepend_before_filter :do_not_reset_user_session_timeout

  def show
    render text: System.get_engines_states.to_json
  end

private

  def do_not_reset_user_session_timeout
   request.env["devise.skip_trackable"] = true
  end

end
