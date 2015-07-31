class ApplicationDisplayPropertiesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_application_display_properties

  def edit
    @application_display_properties.set_icon = "Keep existing icon"
  end

  def update
    # render text: params
    if @application_display_properties.update(application_display_properties_params)
      redirect_to control_panel_path, notice: "Successfully updated display properties for #{application_name}."
    else
      render :edit
    end
  end

private

  def set_application_display_properties
    @application_display_properties = Application.find_by(container_name: application_name).application_display_properties
  end
      
  def application_name
    params[:application_name]
  end

  def application_display_properties_params
    @application_display_properties_params ||= params.require(:application_display_properties).permit! #(:title, :detail, :icon)
  end

end
