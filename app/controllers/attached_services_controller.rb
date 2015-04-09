class AttachedServicesController < ApplicationController

  before_action :authenticate_user!
  
  def index
    @software = Software.find(params[:software_id])
    @software.build_attached_services_handler.load_attached_services
  end

  def new
    @software = Software.find(params[:software_id])
    @attached_services_handler = @software.build_attached_services_handler
    @attached_service = @attached_services_handler.attached_services.build(new_attached_service_attributes)
  end

  def create
    @software = Software.find(params[:software_id])
    @attached_service = @software.build_attached_services_handler.attached_services.build(attached_service_attributes)
    if @attached_service.valid?
      result = EnginesAttachedService.attach_service(build_attached_service_attributes)
      if result.was_success
        redirect_to attached_services_path(software_id: @software.id), notice: "Successfully attached #{@attached_service.title} to #{@software.engine_name}."
      else
        redirect_to attached_services_path(software_id: @software.id), alert: "Failed to attach #{@attached_service.title} to #{@software.engine_name}. #{result.result_mesg}"[0..1000]
      end
    else
      render :new
    end
  end

  def registration
    service_params = params.require(:service).permit(:publisher_namespace, :service_handle, :type_path, :parent_engine)
    result = case params[:service_action]
    when "remove"
      EnginesAttachedService.detach_service service_params
    when "register"
      EnginesAttachedService.register_service service_params
    when "deregister"
      EnginesAttachedService.deregister_service service_params
    when "reregister"
      EnginesAttachedService.reregister_service service_params
    end
    if result.was_success
      redirect_to attached_services_path(software_id: params[:software_id]), notice: "Success. #{result.result_mesg}"[0..1000]
    else
      redirect_to attached_services_path(software_id: params[:software_id]), alert: "Failed. #{result.result_mesg}"[0..1000]
    end
  end

private

  def new_attached_service_attributes
    type_path = params[:attached_service][:type_path]
    publisher_namespace = params[:attached_service][:publisher_namespace]
    attached_service_service_detail = @attached_services_handler.service_detail type_path, publisher_namespace
    {
      type_path: type_path,
      publisher_namespace: publisher_namespace,
      title: attached_service_service_detail[:title],
      description: attached_service_service_detail[:description],
      variables_attributes: (attached_service_service_detail[:setup_params].values if attached_service_service_detail[:setup_params].present?)
    }
  end

  def attached_service_attributes
    params.require(:attached_service).permit(:type_path, :publisher_namespace, :title, :description, variables_attributes: [
      :name, :value, :value_confirmation, :label, :field_type, :select_collection, :tooltip, :hint, :placeholder, 
      :comment, :regex_validator, :regex_invalid_message, :mandatory, :ask_at_build_time, :build_time_only, :immutable
    ])
  end

  def build_attached_service_attributes
    result = {
      parent_engine: @software.engine_name,
      type_path: @attached_service.type_path,
      publisher_namespace: @attached_service.publisher_namespace,
      title: @attached_service.title,
      variables: {}
    }
    @attached_service.variables.each do |variable|
      result[:variables][variable.name.to_sym] = variable.value
    end
    return result
  end

  # def service_detail(type_path, publisher_namespace)
    # @software.attached_services_handler.available_services.find do |service|
      # service[:type_path] == type_path &&
      # service[:publisher_namespace] == publisher_namespace
    # end
  # end

  # def new_attached_service_variable_attributes setup_params
    # variables_params = setup_params.values
    # variables_params.map do |variable_params|
      # {
        # name: variable_params[:name],
        # value: variable_params[:value],
        # label: variable_params[:label],
        # comment: variable_params[:comment],
        # field_type: variable_params[:field_type],
        # regex_validator: variable_params[:regex_validator],
        # regex_invalid_message: variable_params[:regex_invalid_message],
        # mandatory: variable_params[:mandatory] || variable_params[:required],
        # ask_at_build_time: variable_params[:ask_at_build_time],
        # build_time_only: variable_params[:build_time_only],
        # immutable: variable_params[:immutable],
        # tooltip: variable_params[:tooltip],
        # hint: variable_params[:hint],
        # placeholder: variable_params[:placeholder],
        # select_collection: variable_params[:select_collection]
      # }
    # end
  # end

end