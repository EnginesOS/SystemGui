class ResourcesController < ApplicationController

  before_action :authenticate_user!

  def edit
    @software = Software.find(params[:id])
    @software.build_resource.save if @software.resource.nil?
    @software.resource.load_from_api    
  end

  def update
    @software = Software.find(params[:id])
    @software.update_attributes resource_params
    if @software.resource.save_to_api
      redirect_to control_panel_path, notice: "Resources were successfully updated for #{@software.engine_name}."
    else
      render :edit
    end
  end

private

  def resource_params
    @resource_params ||= params.require(:software).permit!
  end

end

