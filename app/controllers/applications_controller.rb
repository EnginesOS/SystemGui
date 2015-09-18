class ApplicationsController < ApplicationController

  before_action :set_application

  include EnginesApplicationSystemActions
  
  # def destroy
    # remove_all_application_data = (params[:software][:remove_all_application_data] == "1")
    # redirect_to delete_image_software_path(id: engine_name, remove_all_application_data: remove_all_application_data)
  # end

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