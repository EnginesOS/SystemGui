class EnginesApplicationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_engines_application

  include EnginesApplicationSystemActions
  
  def uninstall
  end

  def destroy
    remove_all_application_data = (params[:software][:remove_all_application_data] == "1")
    redirect_to delete_image_software_path(id: engine_name, remove_all_application_data: remove_all_application_data)
  end

  def advanced_detail
    render partial: 'advanced_detail'
  end

private

  def set_engines_application
    @engines_application = Engines::Applications::Application.new application_name
  end

  def application_name
    params[:id]
  end

end