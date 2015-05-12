class ApplicationSubservicesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_application_service

  # def edit
    # @application_service.build
  # end

  def new
    @application_service.build
  end

  def create
    # render text: params

    @application_service.assign_attributes(application_service_params)
    if @application_service.valid?
      result = @application_service.create
      if result.was_success
        redirect_to application_services_properties_path(application_id: @application_service.application_name), notice: "Successfully created #{@application_service.title} for #{@application_service.application_name}."
      else
        redirect_to application_services_properties_path(application_id: @application_service.application_name), alert: "Unable to create #{@application_service.title} for #{@application_service.application_name}. #{result.result_mesg}"[0..1000]
      end 
    else
      render :new
    end
  end



private

  def set_application_service
    @application_service ||= ApplicationService.new(
                                            application_name: application_name,
                                            publisher_namespace: application_service_params[:publisher_namespace],
                                            type_path: application_service_params[:type_path])
  end
      
  def application_name
    params[:application_id]
  end

  def application_service_params
    params.require(:application_service).permit!
  end

end


