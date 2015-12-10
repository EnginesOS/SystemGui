class DesktopsController < ApplicationController

  def show
    @applications = Application.desktop_applications
    render layout: 'desktop'
  end

end
