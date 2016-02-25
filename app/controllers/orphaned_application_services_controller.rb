class OrphanedApplicationServicesController < ApplicationController

  include Engines::Api

  def destroy
    title = params[:service][:service_container_name].to_s + " on " + params[:service][:parent_engine].to_s
    result = engines_api.delete_orphaned_service(orphaned_service_params_hash)
    if result.was_success
      flash[:notice] = "Deleted " + title
    else
      flash[:alert] = "Unable to delete " + title + ". " + result.result_mesg[0..500]
    end
    redirect_to services_registry_path
  end

  def orphaned_service_params
    params.require(:service).permit!
  end

  def orphaned_service_params_hash
    {
      container_type: orphaned_service_params[:container_type],
      parent_engine: orphaned_service_params[:parent_engine],
      publisher_namespace: orphaned_service_params[:publisher_namespace],
      service_handle: orphaned_service_params[:service_handle],
      type_path: orphaned_service_params[:type_path]
    }
  end

end
