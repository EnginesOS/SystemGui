class ControlPanelEnginesToReloadsController < ApplicationController

  def show
    render text: System.get_changed_containers
  end

end
