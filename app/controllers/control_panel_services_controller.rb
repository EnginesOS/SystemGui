class ControlPanelServicesController < ApplicationController


  def show
    @service = Service.load_by_container_name(service_name)
    render partial: 'show'
  end

private

  def service_name
    params[:service_name]
  end

end
