class ServiceConfiguration < ActiveRecord::Base

  include Engines::Api

  attr_accessor :service_name, :configurator_name, :engines_api_error
  
  has_many :variables, as: :variable_consumer, dependent: :destroy
  accepts_nested_attributes_for :variables

  def load
    load_variable_configurations && load_variable_values
    self
  end

  def load_variable_configurations
    service.configurators_hash[configurator_name.to_sym][:params].values.each do |configuration|
      variables.build(configuration)
    end
  end

  def load_variable_values
    variables.each do |variable|
      
p :variable
p variable.name.to_sym      
      
      if variable_values[variable.name.to_sym].present?
        variable.value = variable_values[variable.name.to_sym]
      end
    end
  end

  def service
    @service = Service.where(container_name: service_name).new
  end

  def update(resources_properties_params)
    assign_attributes resources_properties_params
    valid? && save
  end

  def save
    result = engines_api.update_service_configuration service_name: service_name, configurator_name: configurator_name, variables: update_service_configuration_variables_params
    if !result.was_success
      @engines_api_error = "Unable to configure service. " + (result.result_mesg.present? ? result.result_mesg : "No result message given by engines api.")
    end
    result.was_success
  end
  
  def new_record?
    false
  end
  
# private
 
  def variable_values
    @service.service_configuration_variables_for(configurator_name)
  end
  
  def update_service_configuration_variables_params
    {}.tap do |result|
      variables.each do |variable|
        result[variable.name] = variable.value
      end
    end
  end
 
end
