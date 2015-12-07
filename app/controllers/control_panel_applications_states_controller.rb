class ControlPanelApplicationsStatesController < ApplicationController

  def show
    render text: System.get_engines_states
  end

end
