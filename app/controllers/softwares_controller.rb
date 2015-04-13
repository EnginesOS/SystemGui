class SoftwaresController < ApplicationController

  before_action :authenticate_user!

  include EnginesSoftwaresActions
  
  def index
    @softwares = Software.all
  end

  def uninstall
    @software = Software.find(params[:id])
  end

  def uninstall_engine
    # render text: params
    engine_name = Software.find(params[:id]).engine_name
    remove_all_application_data = (params[:software][:remove_all_application_data] == "1")
    # render text: remove_all_application_data
    redirect_to delete_image_software_path(id: engine_name, remove_all_application_data: remove_all_application_data)
    #render text: uninstall_software_params
    
  end

  # def update
    # render text: params
  # end
  
  # def uninstall_engine
  # end

  def destroy_all_records
    Software.delete_all
    redirect_to softwares_path 
  end

  def advanced_detail
    @engine_name = params[:id]
    render partial: 'advanced_detail'
  end

end