class ApplicationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_application

  include EnginesApplicationSystemActions
  
  # def destroy
    # remove_all_application_data = (params[:software][:remove_all_application_data] == "1")
    # redirect_to delete_image_software_path(id: engine_name, remove_all_application_data: remove_all_application_data)
  # end

private

  def set_application
    @application = Application.find_by(container_name: application_name)
  end

  def application_name
    params[:id]
  end

end