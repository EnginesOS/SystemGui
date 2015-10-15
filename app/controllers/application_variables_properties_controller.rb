class ApplicationVariablesPropertiesController < ApplicationController

  before_action :set_application_variables_properties

  def edit
    load_variables
  end

  def update
    if @application_variables_properties.update application_variables_properties_params
      redirect_to control_panel_path, notice: "Successfully updated application variables for #{@application_variables_properties.application_name}."
    else
      render :edit
    end
  end

private

  def load_variables
    @application_variables_properties.load
  end

  def set_application_variables_properties
    @application_variables_properties = Application.find_by(container_name: application_name).build_application_variables_properties
  end
      
  def application_name
    params[:application_name]
  end

  def application_variables_properties_params
    params.require(:application_variables_properties).permit!
  end
  
end
