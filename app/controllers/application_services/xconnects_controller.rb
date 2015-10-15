class ApplicationServices::ConnectsController < ApplicationController

  before_action :set_application_service_connect

  def new
    render text: params
    # if @application_service_connect.connect_service
      # redirect_to application_services_properties_path(application_name: @application_service_connect.application_name), 
        # notice: "Successfully connected #{@application_service_connect.service_title} to #{@application_service_connect.application_name}."
    # else
      # set_application_service
      # render :new
    # end
  end

private

  def set_application_service_connect
    @application_service_connect = ApplicationServices::Connect.new(application_name, application_service_params)
  end

  def set_application_service
    @application_service = @application_service_connect.application_service
  end

  def application_name
    params[:application_name]
  end

  def application_service_params
    params.require(:application_service).permit!
  end

end

  
