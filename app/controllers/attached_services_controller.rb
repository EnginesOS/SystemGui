class AttachedServicesController < ApplicationController

  before_action :authenticate_user!
  
  def index
    @software = Software.find(params[:software_id])
    # @software.attached_services_handler.destroy if @software.attached_services_handler.present?
    @software.build_attached_services_handler.load_attached_services
  end

  def new
    @software = Software.find(params[:software_id])

    available_services = EnginesSoftware.available_services(@software.engine_name)

    service_detail = available_services.find do |service|
      service[:service_type] == params[:service_type] &&
      service[:service_provider] == params[:service_provider]
    end

    @attached_service = @software.build_attached_services_handler.attached_services.build(
      {
        service_type: params[:service_type],
        service_provider: params[:service_provider],
        title: service_detail[:title],
        variables_attributes: variables_attributes(service_detail[:setup_params].values)
      })

  end

  def create
    render text: params
  end


private

  def variables_attributes variables_params

    variables_params.map do |variable|
      {
        name: variable[:name],
        label: variable[:label],
        regex_validator: variable[:regex_validator],
        type: variable[:type],
        tooltip: variable[:tooltip],
        hint: variable[:hint],
        placeholder: variable[:placeholder],
        mandatory: variable[:mandatory],
        value: variable[:value],
        comment: variable[:comment]
      }
    end
  end


  # def 
  #   @volumes = EnginesSoftware.volumes(@software.engine_name).map(&:name)
  #   @databases = EnginesSoftware.databases(@software.engine_name).map(&:name)
  # end

end