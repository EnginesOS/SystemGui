class ServicesPropertiesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_services_properties
  
  def show
  end

private
   
  def set_services_properties
    @application = Application.find_by(container_name: application_name)
    @services_properties = @application.services_properties.load
  end
      
  def application_name
    params[:application_name]
  end
  
end
