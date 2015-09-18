class ControlPanelsController < ApplicationController


  def show
    @applications = Application.load_all
  end
  
  def services
    @services = Service.load_all
  end

end
