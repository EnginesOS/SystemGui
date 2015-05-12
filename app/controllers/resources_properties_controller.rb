class ResourcesPropertiesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_resources_properties

  def edit
    @resources_properties.load
  end

  def update
    if @resources_properties.update(resources_properties_params)
      redirect_to control_panel_path, notice: "Successfully updated resources properties for #{@resources_properties.application_name}."
    else
      render :edit
    end
  end

private

  def set_resources_properties
    @resources_properties = Application.find_by(container_name: application_name).build_resources_properties
  end
      
  def application_name
    params[:application_name]
  end

  def resources_properties_params
    params.require(:resources_properties).permit(:memory, :required_memory)
  end

end


