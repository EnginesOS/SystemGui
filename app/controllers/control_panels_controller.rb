class ControlPanelsController < ApplicationController

  def show
    @application_names = Application.application_container_names_listx
    # render text: BuildController.new(1).methods
  end
  
  def services
    @service_names = Service.service_container_names_list
  end

end
