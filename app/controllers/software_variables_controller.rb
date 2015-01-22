class SoftwareVariablesController < ApplicationController

  before_action :authenticate_user!

  def edit
    @software = Software.find(params[:id])
    @software.build_software_variable.load_software_variables_from_api
  end

  def update
    @software = Software.find(params[:id])
    @software.update_attributes variables_params
    if @software.valid?
      if @software.software_variable.save_to_api
        redirect_to control_panel_path, notice: "Software variables were successfully updated for #{@software.engine_name}."
      else
        redirect_to control_panel_path, alert: "Software variables were not updated for #{@software.engine_name}."
      end  
    else
      render :edit
    end
  end

private

  def variables_params
    params.require(:software).permit!
  end

end

