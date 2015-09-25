class DesktopsController < ApplicationController

  def show
    @applications = Application.desktop_applications
    @desktop_settings = DesktopSettings.instance
    render layout: 'desktop'
  end

end
