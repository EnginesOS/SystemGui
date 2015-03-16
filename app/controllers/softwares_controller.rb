class SoftwaresController < ApplicationController

  include EnginesSoftwaresActions

  before_action :authenticate_user!
  
  def index
    @softwares = Software.all
  end

  def uninstall
    @software = Software.find(params[:id])
  end
  
  def uninstall_engine
    render text: params
  end

  def destroy_all_records
    Software.delete_all
    redirect_to softwares_path 
  end

  def advanced_detail
    @engine_name = params[:id]
    render partial: 'advanced_detail'
  end

end