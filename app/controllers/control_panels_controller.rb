class ControlPanelsController < ApplicationController

  before_action :authenticate_user!

  def show
    # Application.delete_all
    @services = Service.load_all
    @applications = Application.load_all
  end

end