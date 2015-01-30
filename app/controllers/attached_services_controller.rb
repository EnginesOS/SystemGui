class AttachedServicesController < ApplicationController

  before_action :authenticate_user!
  
  def index
    @software = Software.find(params[:software_id])
    # @software.attached_services_handler.destroy if @software.attached_services_handler.present?
    @software.build_attached_services_handler.load_attached_services
  end

  def new
    @software = Software.find(params[:software_id])
    @attached_service = @software.build_attached_services_handler.
      attached_services.build(new_attached_service_attributes)
  end

  def create
    # render text: params

    api_create_params = params["attached_service"].permit!
    api_create_params["variables_attributes"].values.each do |variable|
      api_create_params[variable["name"]] = variable["value"]
    end
    api_create_params.delete("variables_attributes")

    result = EnginesAttachedService.attach_service api_create_params

    render text: result

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

  def new_attached_service_variable_attributes

    available_services = EnginesSoftware.available_services(@software.engine_name)
    service_detail = available_services.find do |service|
      service[:service_type] == params[:service_type] &&
      service[:service_provider] == params[:service_provider]
    end

    variables_params = service_detail[:setup_params].values

    variables_params.map do |variable|
      {
        name: variable[:name],
        value: variable[:value],
        label: variable[:label],
        comment: variable[:comment],
        type: variable[:type],
        regex_validator: variable[:regex_validator],
        mandatory: variable[:mandatory],
        ask_at_build_time: variable[:ask_at_build_time],
        build_time_only: variable[:build_time_only],
        immutable: variable[:immutable],
        tooltip: variable[:tooltip],
        hint: variable[:hint],
        placeholder: variable[:placeholder],
        collection: variable[:collection]
      }
    end
  end

  # def 
  #   @volumes = EnginesSoftware.volumes(@software.engine_name).map(&:name)
  #   @databases = EnginesSoftware.databases(@software.engine_name).map(&:name)
  # end

end