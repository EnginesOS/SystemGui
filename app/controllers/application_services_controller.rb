class ApplicationServicesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_application_service

  def new
    @application_service.load_variables
  end

  def create
    if @application_service.create
      redirect_to services_properties_path(application_name: @application_service.application_name), notice: "Successfully attached #{@application_service.title} to #{@application_service.application_name}."
    else
      render :new
    end
  end

private

  def set_application_service
    @application_service ||= Application.find_by(container_name: application_name).application_services.build(application_service_params)
  end

  def application_name
    params[:application_name]
  end

  def application_service_params
    params.require(:application_service).permit!
  end

end
