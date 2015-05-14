class OrphanedApplicationServicesController < ApplicationController

  include Engines::Api

  before_action :authenticate_user!

  def destroy
    title = params[:service][:service_container_name].to_s + " on " + params[:service][:parent_engine].to_s
    result = engines_api.delete_orphaned_service(params[:service])
    if result.was_success
      flash[:notice] = "Deleted " + title
    else
      flash[:alert] = "Unable to delete " + title + ". " + result.result_mesg
    end
    redirect_to services_registry_path
  end

end
