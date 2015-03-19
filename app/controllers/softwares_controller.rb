class SoftwaresController < ApplicationController

  include EnginesSoftwaresActions

  before_action :authenticate_user!
  
  def index
    @softwares = Software.all
  end

  def uninstall
    @software = Software.find(params[:id])
  end
  
  # def uninstall_engine
    # engine_name = Software.find(params[:id]).engine_name
    # remove_all_application_data = (params[:software][:remove_all_application_data] == "1")
    # redirect_to softwares_delete_image_path(engine_name, remove_all_application_data: remove_all_application_data)
    # #render text: uninstall_software_params
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