class ApplicationUninstallsController < ApplicationController

  include Engines::Api

  before_action :authenticate_user!

  def show
    @application_uninstall = ApplicationUninstall.new application_name: params[:application_name]
  end

  def create
    @application_uninstall = ApplicationUninstall.new application_uninstall_params
    if @application_uninstall.uninstall
      redirect_to control_panel_path, notice: "Successfully uninstalled #{@application_uninstall.application_name}."
    end
  end

private

  def application_uninstall_params
    params.require(:application_uninstall).permit!
  end

end
