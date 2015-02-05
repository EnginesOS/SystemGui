class AttachedServicesController < ApplicationController

  before_action :authenticate_user!
  
  def index
    @software = Software.find(params[:software_id])
    @software.build_attached_services_handler.load_attached_services
  end

  def new
    @software = Software.find(params[:software_id])
    @attached_service = @software.build_attached_services_handler.
      attached_services.build(new_attached_service_attributes)
  end

  def create
    @software = Software.find(params[:software_id])
    @attached_service = @software.build_attached_services_handler.
      attached_services.build(create_attached_service_attributes)
    if @attached_service.valid?
      result = EnginesAttachedService.attach_service(build_attached_service_attributes)
      if result == true
        redirect_to control_panel_path, notice: "Successfully attached #{@attached_service.label} to #{@software.engine_name}."
      else
        flash[:alert] = (params.to_s + '<br><br>attach_service ' + build_attached_service_attributes.to_s + '<br><br>' + result.to_s).html_safe
        render :new
      end
    else
      render :new
    end
  end

private

  def new_attached_service_attributes
    {
      service_type: params[:service_type],
      service_provider: params[:service_provider],
      title: params[:title],
      variables_attributes: new_attached_service_variable_attributes
    }
  end

  def create_attached_service_attributes
    attached_service_params = params[:attached_service]
    {
      service_type: attached_service_params[:service_type],
      service_provider: attached_service_params[:service_provider],
      title: attached_service_params[:title],
      variables_attributes: attached_service_params[:variables_attributes].values
    }
  end

  def build_attached_service_attributes
    result = {
      parent_engine: @software.engine_name,
      service_type: @attached_service.service_type,
      service_provider: @attached_service.service_provider,
      title: @attached_service.title,
    }
    @attached_service.variables.each do |variable|
      result[variable.name.to_sym] = variable.value
    end
    return result
  end

  def service_detail service_type, service_provider
    EnginesSoftware.available_services(@software.engine_name).find do |service|
      service[:service_type] == service_type &&
      service[:service_provider] == service_provider
    end[:setup_params].values
  end

  def new_attached_service_variable_attributes
    variables_params = service_detail params[:service_type], params[:service_provider]
    variables_params.map do |variable_params|
      {
        name: variable_params[:name],
        value: variable_params[:value],
        label: variable_params[:label],
        comment: variable_params[:comment],
        type: variable_params[:type],
        regex_validator: variable_params[:regex_validator],
        regex_invalid_message: variable_params[:regex_invalid_message],
        mandatory: variable_params[:mandatory] || variable_params[:required],
        ask_at_build_time: variable_params[:ask_at_build_time],
        build_time_only: variable_params[:build_time_only],
        immutable: variable_params[:immutable],
        tooltip: variable_params[:tooltip],
        hint: variable_params[:hint],
        placeholder: variable_params[:placeholder],
        collection: variable_params[:collection]
      }
    end
  end

end