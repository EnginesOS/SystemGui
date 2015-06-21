class ControlPanelApplicationsController < ApplicationController

  before_action :authenticate_user!

  def show
    @application = Application.load_by_container_name(application_name)
    render partial: 'show'
  end

private

  def application_name
    params[:application_name]
  end

end
