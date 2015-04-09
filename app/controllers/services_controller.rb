class ServicesController < ApplicationController

  include EnginesServicesActions

  before_action :authenticate_user!

  def advanced_detail
    @service_name = params[:id]
    render partial: "advanced_detail"
  end

  def registry
    @services_tree_by_provider = EnginesService.services_tree_by_provider
    @services_tree_by_engine = EnginesService.services_tree_by_engine
    @services_tree_of_orphaned_services = EnginesService.services_tree_of_orphaned_services
  end

  def delete_orphaned_attached_service
    title = params[:service][:service_container_name].to_s + " on " + params[:service][:parent_engine].to_s
    result = EnginesAttachedService.delete_orphaned_service(params[:service])
    if result.was_success
      flash[:notice] = "Deleted " + title
    else
      flash[:alert] = "Unable to delete " + title + ". " + result.result_mesg
    end
    redirect_to :registry
  end

end

