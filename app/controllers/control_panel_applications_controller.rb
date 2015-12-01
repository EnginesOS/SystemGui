class ControlPanelApplicationsController < ApplicationController

  def show
    @application = Application.load_by_container_name(application_name)
    if @application
      render partial: 'show'
    else
      render status: 520
    end
  end

private

  def application_name
    params[:application_name]
  end

end
