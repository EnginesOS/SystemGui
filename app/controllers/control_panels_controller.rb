class ControlPanelsController < ApplicationController

  def show
    @applications = Application.load_all
    # render text: BuildController.new(1).methods
  end
  
  def services
    @services = Service.load_all
  end

end
