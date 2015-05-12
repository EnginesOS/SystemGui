class ServicesPropertiesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_services_properties
  
  def show
  end

private
   
  def set_services_properties
    @services_properties = Application.find_by(container_name: application_name).build_services_properties
  end
      
  def application_name
    params[:application_name]
  end
  
end
