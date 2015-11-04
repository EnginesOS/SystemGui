class ApplicationsController < ApplicationController

  before_action :set_application

  include EnginesApplicationSystemActions

  def open
    if @application.primary_web_site.present?
      redirect_to @application.primary_web_site, target: @application.container_name
    else
      render text: "No website URL for #{@application.container_name}", target: @application.container_name
    end
  end

private

  def set_application
    @application = Application.where(container_name: application_name).first_or_create
  end

  def application_name
    params[:application_name]
  end

end