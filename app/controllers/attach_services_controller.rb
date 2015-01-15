class AttachServicesController < ApplicationController

  before_action :authenticate_user!
  
  def show
    @software = Software.find(params[:id])
    @available_services = EnginesAttachServices.available_services_for @software
  end

end