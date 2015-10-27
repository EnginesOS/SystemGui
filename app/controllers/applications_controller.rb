class ApplicationsController < ApplicationController

  before_action :set_application

  include EnginesApplicationSystemActions

  def open
    redirect_to @application.primary_web_site, target: @application.container_name
  end

private

  def set_application
    @application = Application.where(container_name: application_name).first_or_create
  end

  def application_name
    params[:application_name]
  end

end