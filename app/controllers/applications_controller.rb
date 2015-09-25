class ApplicationsController < ApplicationController

  before_action :set_application

  include EnginesApplicationSystemActions

  def open
    redirect_to @application.primary_web_site, target: @application.container_name
  end

private

  def set_application
    @application = Application.find_by(container_name: application_name)
  end

  def application_name
    params[:application_name]
  end

end