class ApplicationServicesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_application
  before_action :set_application_service

  def new
    @application_service.build_new
  end

  def edit
    # render text: params
    @application_service.build_edit
  end

  def create
    if @application_service.create
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), notice: "Successfully connected #{@application_service.title} to #{@application_service.application.container_name}."
    else
      render :new
    end
  end

  def update
    if @application_service.update
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), notice: "Successfully updated #{@application_service.title} on #{@application_service.application.container_name}."
    else
      render :edit
    end
  end

  def destroy
    if @application_service.destroy
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), notice: "Successfully removed #{@application_service.title} from #{@application_service.application.container_name}."
    else
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), notice: "Unable to remove #{@application_service.title} from #{@application_service.application.container_name}."
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
