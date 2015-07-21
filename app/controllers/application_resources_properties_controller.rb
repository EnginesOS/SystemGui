class ApplicationResourcesPropertiesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_application_resources_properties

  def edit
    @application_resources_properties.load
  end

  def update
    if @application_resources_properties.update(application_resources_properties_params)
      redirect_to control_panel_path, notice: "Successfully updated resources properties for #{@application_resources_properties.application_name}."
    else
      render :edit
    end
  end

private

  def set_application_resources_properties
    @application_resources_properties = Application.find_by(container_name: application_name).build_application_resources_properties
  end
      
  def application_name
    params[:application_name]
  end

  def application_resources_properties_params
    params.require(:application_resources_properties).permit(:memory, :required_memory)
  end

end


