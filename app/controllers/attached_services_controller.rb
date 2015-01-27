class AttachedServicesController < ApplicationController

  before_action :authenticate_user!
  
  def index
    @software = Software.find(params[:software_id])
    @software.attached_services.clear
# @x = AttachedService.params_from_api_data(@software.engine_name)
# p "AttachedService.params_from_api_data(@software.engine_name)"
# p @x
    @software.attached_services.build(AttachedService.params_from_api_data(@software.engine_name))
    @available_services = EnginesSoftware.available_services(@software.engine_name)
  end


  # def 
  #   @volumes = EnginesSoftware.volumes(@software.engine_name).map(&:name)
  #   @databases = EnginesSoftware.databases(@software.engine_name).map(&:name)
  # end

end