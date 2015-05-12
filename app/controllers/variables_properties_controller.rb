class VariablesPropertiesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_variables_properties

# def show
      # result = @variables_properties.variables
    # render text: result.map{|r| r.value}
# end


  def edit
  end

  def update
    if @variables_properties.update(variables_properties_params)
      redirect_to control_panel_path, notice: "Successfully updated application variables for #{@variables_properties.application_name}."
    else
      render :edit
    end
  end

private

  def set_variables_properties
    @variables_properties = Application.find_by(container_name: application_name).build_variables_properties
  end
      
  def application_name
    params[:application_name]
  end

  def variables_properties_params
    params.require(:variables_properties).permit!
  end
  
end
