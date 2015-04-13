class AttachedSubservicesController < ApplicationController

  before_action :authenticate_user!
  
  def new
    @software = Software.find(params[:software_id])
    @attached_services_handler = @software.build_attached_services_handler
    @attached_service = @attached_services_handler.attached_services.build(attached_service_attributes)
    @attached_subservice = @attached_service.attached_subservices.build(new_attached_subservice_attributes)
  end

  def create
    # render text: params
    @software = Software.find(params[:software_id])
    @attached_services_handler = @software.build_attached_services_handler
    @attached_service = @attached_services_handler.attached_services.build(attached_service_attributes)
    @attached_subservice = @attached_service.attached_subservices.build(attached_subservice_attributes)

    if @attached_subservice.valid?
      result = EnginesAttachedService.attach_service(build_attached_subservice_attributes)
      if result.was_success == true
        redirect_to attached_services_path(software_id: @software.id), notice:
          "Successfully attached #{@attached_subservice.title} to #{@attached_service.title} on #{@software.engine_name}."
      else
        redirect_to attached_services_path(software_id: @software.id), alert:
          "Failed to attach #{@attached_subservice.title} to #{@attached_service.title} on #{@software.engine_name}. #{result.result_mesg}"[0..1000]
      end
    else
      render :new
    end
  end

private

  def attached_service_attributes
    {
      service_handle: params[:parent_service_handle],
      title: params[:parent_title]
    }
  end

  def new_attached_subservice_attributes
    type_path = params[:attached_subservice][:type_path]
    publisher_namespace = params[:attached_subservice][:publisher_namespace]
    attached_service_service_detail = @attached_services_handler.service_detail type_path, publisher_namespace
    {
      type_path: type_path,
      publisher_namespace: publisher_namespace,
      title: attached_service_service_detail[:title],
      description: attached_service_service_detail[:description],
      variables_attributes: (attached_service_service_detail[:consumer_params].values if attached_service_service_detail[:consumer_params].present?)
    }
  end
  
  # def attached_service_attributes
    # {service_handle: params[:attached_subservice][:parent_service_handle]}
  # end

  def attached_subservice_attributes
    params.require(:attached_subservice).permit(:type_path, :publisher_namespace, :title, :description, :parent_service_handle, variables_attributes: [
      :name, :value, :value_confirmation, :label, :field_type, :select_collection, :tooltip, :hint, :placeholder, 
      :comment, :regex_validator, :regex_invalid_message, :mandatory, :ask_at_build_time, :build_time_only, :immutable
    ])
  end

  def build_attached_subservice_attributes
    result = {
      parent_service_handle: @attached_service.service_handle,
      type_path: @attached_subservice.type_path,
      publisher_namespace: @attached_subservice.publisher_namespace,
      title: @attached_subservice.title,
      variables: {}
    }
    @attached_subservice.variables.each do |variable|
      result[:variables][variable.name.to_sym] = variable.value
    end
    return result
  end
  
end