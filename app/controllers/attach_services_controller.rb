class AttachServicesController < ApplicationController

  before_action :authenticate_user!
  
  def show
    @software = Software.find(params[:id])
    @engine = EnginesSoftware.engines_software @software.engine_name
    @available_services = EnginesAttachServices.available_services_for @engine
  end

end