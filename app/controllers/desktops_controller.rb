class DesktopsController < ApplicationController

  before_action :authenticate_user!

  def show
    @applications = Application.desktop_applications
    @desktop_settings = DesktopSettings.instance
    render layout: false
  end

end
