class DesktopApplicationsController < ApplicationController


  def show
    @application = Application.load_by_container_name(application_name)
    @desktop_settings = DesktopSettings.instance
    render partial: 'show'
  end

private

  def application_name
    params[:application_name]
  end

end
