class DisplayPropertiesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_display_properties

  def edit
  end

  def update
    if @display_properties.update(display_properties_params)
      redirect_to control_panel_path, notice: "Successfully updated display properties for #{application_name}."
    else
      render :edit
    end
  end

private

  def set_display_properties
    @display_properties = Application.find_by(container_name: application_name).display_properties
  end
      
  def application_name
    params[:application_name]
  end

  def display_properties_params
    params.require(:display_properties).permit(:title, :detail, :icon)
  end

end
