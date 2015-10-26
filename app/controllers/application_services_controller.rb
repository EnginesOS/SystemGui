class ApplicationServicesController < ApplicationController

  before_action :set_application_service

  def edit
    @application_service.existing_connection.build_edit
  end

  def update
    # render text: @application_service.existing_connection.update_params
    if @application_service.update
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), 
        notice: "Successfully updated #{@application_service.application.container_name} #{@application_service.existing_connection.service_detail.title}." + 
                  @application_service.engines_api_error.to_s
    else
      render :edit
    end
  end

  def destroy
    # render text: @application_service.existing_connection.connection_params
    if @application_service.destroy
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), 
        notice: "Successfully removed #{@application_service.existing_connection.service_detail.title} from #{@application_service.application.container_name}."
    else
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), 
        alert: "Unable to remove #{@application_service.existing_connection.service_detail.title} from #{@application_service.application.container_name}." + 
                  @application_service.engines_api_error.to_s
    end
  end
  
  def action
    if @application_service.perform_action
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), 
        notice: "Successfully performed #{@application_service.service_action} action on #{@application_service.existing_connection.service_detail.title}."
    else
      redirect_to application_services_properties_path(application_name: @application_service.application.container_name), 
        alert: "Unable to perform #{@application_service.service_action} action on #{@application_service.existing_connection.service_detail.title}. " + 
                  @application_service.engines_api_error.to_s
    end
  end

private

  def set_application_service
    @application_service = application.application_services.build(application_service_params)
  end

  def application
    Application.find_by(container_name: application_name)
  end

  def application_name
    params[:application_name]
  end

  def application_service_params
    params.require(:application_service).permit! 
  end

end
