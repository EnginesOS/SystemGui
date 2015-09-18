class ApplicationServicesController < ApplicationController

  before_action :set_application_service

  def new
    redirect_to new_application_services_connect_service_path(
        application_name: application_name,
        application_service: new_application_service_params
      ) if @application_service.nothing_to_share
  end

  def edit
    @application_service.build_for_edit
  end

  def create
    redirect_to new_application_services_connect_service_path(@application_service.new_connect_service_params)
  end

  def update
    if @application_service.update
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), 
        notice: "Successfully updated #{@application_service.title} on #{@application_service.application.container_name}." + 
                  @application_service.engines_api_error.to_s
    else
      render :edit
    end
  end

  def destroy
    if @application_service.destroy
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), 
        notice: "Successfully removed #{@application_service.title} from #{@application_service.application.container_name}."
    else
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), 
        alert: "Unable to remove #{@application_service.title} from #{@application_service.application.container_name}." + 
                  @application_service.engines_api_error.to_s
    end
  end
  
  def action
    if @application_service.perform_action
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), 
        notice: "Successfully performed #{@application_service.service_action} action on #{@application_service.title}."
    else
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), 
        alert: "Unable to perform #{@application_service.service_action} action on #{@application_service.title}. " + 
                  @application_service.engines_api_error.to_s
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

  def new_application_service_params
    application_service_params.merge({create_type: 'new'})
  end

end
