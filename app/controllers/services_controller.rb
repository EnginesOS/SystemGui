class ServicesController < ApplicationController

  include EnginesServicesSystemActions

  before_action :authenticate_user!
  before_action :set_service

  def delete_orphaned_attached_service
    title = params[:service][:service_container_name].to_s + " on " + params[:service][:parent_engine].to_s
    result = EnginesAttachedService.delete_orphaned_service(params[:service])
    if result.was_success
      flash[:notice] = "Deleted " + title
    else
      flash[:alert] = "Unable to delete " + title + ". " + result.result_mesg
    end
    redirect_to services_registry_path
  end

private

  def set_service
    @service = Service.new(container_name: service_name)
  end

  def service_name
    params[:id]
  end

end



 

