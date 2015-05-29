class ControlPanelServicesController < ApplicationController

  before_action :authenticate_user!

  def show
    @service = Service.load_by_container_name(service_name)
    render :show, layout: false
  end

private

  def service_name
    params[:service_name]
  end

end
