class ControlPanelApplicationsStatusesController < ApplicationController

  def show
    render text: System.get_engines_states
  end

end
