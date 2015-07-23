class ApplicationServicesPropertiesController < ApplicationController

  before_action :authenticate_user!

  def show
    @application_services_properties = Application.find_by(container_name: application_name).build_application_services_properties
    @application_services_properties.build_application_services
  end

private

  def application_name
    params[:application_name]
  end

  def application_services_properties_params
    params.require(:application_services_properties).permit!
  end

end
