class ApplicationUninstallsController < ApplicationController

  include Engines::Api


  def show
    @application_uninstall = ApplicationUninstall.new application_name: params[:application_name]
  end

  def create
    @application_uninstall = ApplicationUninstall.new application_uninstall_params
    if @application_uninstall.uninstall
p :redirect_to_control_panel      
      redirect_to control_panel_path, notice: "Successfully uninstalled #{@application_uninstall.application_name}."
    else
      msg = @application_uninstall.engines_api_error
      redirect_to control_panel_path, alert: "Unable to uninstall #{@application_uninstall.application_name}. " + ( msg.present? ? msg : "No api result." )
    end
  end

private

  def application_uninstall_params
    params.require(:application_uninstall).permit!
  end

end
