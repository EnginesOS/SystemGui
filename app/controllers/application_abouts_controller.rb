class ApplicationAboutsController < ApplicationController

  before_action :authenticate_user!

  def show
    @application = Application.find_by(container_name: application_name)
    render layout: false
  end

private

  def application_name
    params[:application_name]
  end

end