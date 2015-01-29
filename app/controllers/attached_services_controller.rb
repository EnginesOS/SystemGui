class AttachedServicesController < ApplicationController

  before_action :authenticate_user!
  
  def index
    @software = Software.find(params[:software_id])
    @software.build_attached_services_handler.load_attached_services
  end

  def new
    @software = Software.find(params[:software_id])
    @software.attached_services_handler.attached_services.clear
    @software.attached_services_handler.
      attached_services.build(AttachedService.params_from_api_data(@software.engine_name))
  end



  # def 
  #   @volumes = EnginesSoftware.volumes(@software.engine_name).map(&:name)
  #   @databases = EnginesSoftware.databases(@software.engine_name).map(&:name)
  # end

end