class ApplicationServicesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_application_service

  def select_new
    select_redirect_to_new if @application_service.nothing_to_share
  end
  
  def create_new
    @application_service.build_new
    render :new
  end

  def select_redirect_to_new
      redirect_to new_application_services_path(
        application_name: @application_service.application.container_name,
        application_service: {
          type_path: @application_service.type_path,
          publisher_namespace: @application_service.publisher_namespace,
        }
      )
  end

  def new
    @application_service.build_new
  end

  def edit
    # render text: params
    @application_service.build_edit
  end

  def create
    if @application_service.create
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), 
        notice: "Successfully connected #{@application_service.title} to #{@application_service.application.container_name}." + 
                  @application_service.engines_api_error.to_s
    else
      render :new
    end
  end

  def update
    # render text: params
    # render text: @application_service.to_json
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
    # render text: application_service_params
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

end
