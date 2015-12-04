class ControlPanelsController < ApplicationController

  def show
    @application_names = Application.application_container_names_list
  end

  def services
    @service_names = Service.service_container_names_list
  end

end
