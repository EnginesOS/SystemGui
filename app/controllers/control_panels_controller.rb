class ControlPanelsController < ApplicationController

  before_action :authenticate_user!

  def show
    @services = Service.load_all
    @applications = Application.load_all
  end

end
