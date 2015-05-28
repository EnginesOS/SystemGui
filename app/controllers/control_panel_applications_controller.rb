class ControlPanelApplicationsController < ApplicationController

  before_action :authenticate_user!

  def show
    
    p :application_name
    p application_name
    
    @application = Application.load_by_container_name(application_name)
    render :show, layout: false
  end

private

  def application_name
    params[:application_name]
  end

end
