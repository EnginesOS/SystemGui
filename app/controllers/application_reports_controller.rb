class ApplicationReportsController < ApplicationController

  before_action :authenticate_user!

  def show
    @application = Application.find_by(container_name: application_name)
    render layout: false
    
    
    # render text: @application.build_services_properties.application_services.map(&:attached_services_hash)
    
  end

private

  def application_name
    params[:application_name]
  end

end