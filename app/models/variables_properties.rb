class VariablesProperties < ActiveRecord::Base

  include Engines::Api

  after_initialize :load

  belongs_to :application
  has_many :variables, through: :application
  accepts_nested_attributes_for :variables

  def application_name
    application.container_name
  end

  def save
    update_variables
  end

  def new_record?
    false
  end 
  
  def update(variables_properties_params)
    assign_attributes variables_properties_params
    valid? && save
  end

  def load
    variables_definitions.each do |variable_definition|
      variables.build(variable_definition)
    end if variables_definitions.is_a? Array
  end
  
  def variables_definitions
    application.blueprint_software_details['variables']
  end


  def update_variables
    engines_api.set_engine_runtime_properties update_params
  end

  
  def update_params
    {
      engine_name: application_name,
      environment_variables: variables_update_params
    }
  end

  def variables_update_params
    params = {}
    variables.map do |variable|
      params[variable.name] = variable.value
    end
    params
  end

  

end
