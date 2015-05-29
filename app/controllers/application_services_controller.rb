class ApplicationServicesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_application
  before_action :set_application_service, except: :show

  def show
    @application.load_application_services
  end

  def new
    @application_service.load_variable_definitions
  end

  def create
    if @application_service.create
      redirect_to application_services_path(application_name: @application_service.application.container_name), notice: "Successfully attached #{@application_service.title} to #{@application_service.application.container_name}."
    else
      render :new
    end
  end

private

  def set_application_service
    @application_service ||= @application.application_services.build(application_service_params)
  end

  def set_application
    @application ||= Application.find_by(container_name: application_name)
  end

  def application_name
    params[:application_name]
  end

  def application_service_params
    params.require(:application_service).permit!
  end

end
