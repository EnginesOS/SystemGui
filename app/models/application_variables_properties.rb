class ApplicationVariablesProperties < ActiveRecord::Base

  include Engines::Api

  # after_initialize :load

  belongs_to :application
  # has_many :variables, as: :variable_consumer, dependent: :destroy
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
  
  def update(application_variables_properties_params)
    assign_attributes application_variables_properties_params
    valid? && save
  end

  def load
    if variables_definitions.is_a? Array
      variables_values = environment_variables
      variables_definitions.each do |variable_definition|        
        if variable_definition['build_time_only'] != true
          variables.build(variable_definition)
        end
      end
      variables.each do |v|
        v.value = variables_values[v.name]
      end
    end
  end
  
  def variables_definitions
    application.blueprint_software_details['variables']
  end
  
  def environment_variables
    result = {}
    application.environments.each do |environment_variable|
      result[environment_variable.name] = environment_variable.value
    end
    result
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
