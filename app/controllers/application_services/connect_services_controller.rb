class ApplicationServices::ConnectServicesController < ApplicationController

  before_action :set_application_service

  def new
    @application_service.load_variables
  end
  
  def create
    # ApplicationServices::ConnectActive.new(application_name: application_name, application_service: application_service_params)
  # end
  # def create
    if @application_service.connect_service
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), 
        notice: "Successfully connected #{@application_service.title} to #{@application_service.application.container_name}." + 
                  @application_service.engines_api_error.to_s
    else
      render :new
    end
  end



private

  def set_application_service
    set_application
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

  
