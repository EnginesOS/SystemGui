class DesktopApplicationsController < ApplicationController


  def show
    @application = Application.load_by_container_name(application_name)
    @display_settings = DisplaySettings.instance
    render partial: 'show'
  end

private

  def application_name
    params[:application_name]
  end

end
