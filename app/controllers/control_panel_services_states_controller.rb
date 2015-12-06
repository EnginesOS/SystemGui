class ControlPanelServicesStatesController < ApplicationController

  def show
    render text: System.get_services_states
  end

end
