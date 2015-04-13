class ResourcesController < ApplicationController

  before_action :authenticate_user!

  def edit
    @software = Software.find(params[:id])
    @software.build_resource( Resource.api_data_for(@software.engine_name) )
  end

  def update
    @software = Software.find(params[:id])
    @software.build_resource resource_params
    if !@software.valid?
      render :edit
    elsif 
      update_result = @software.resource.save_to_api
      if update_result.was_success == true
        redirect_to control_panel_path, notice: "Resources were successfully updated for #{@software.engine_name}."
      else
        redirect_to control_panel_path, alert: "Resources were not updated for #{@software.engine_name}. (" + update_result.result_mesg[0..250] + ')'
      end
    end
  end

private

  def resource_params
    @resource_params ||= params.require(:software).require(:resource_attributes).permit!
  end

end

