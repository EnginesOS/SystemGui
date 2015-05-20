class ServiceConfiguration < ActiveRecord::Base

  include Engines::Api

  attr_accessor :service_name, :configurator_name
  
  has_many :variables, as: :variable_consumer, dependent: :destroy
  accepts_nested_attributes_for :variables

  def load
    service.configurators_hash[configurator_name.to_sym][:params].values.each do |configuration|
      variables.build(configuration)
    end
    self
  end

  def service
    @service = Service.where(container_name: service_name).new
  end

  def update(resources_properties_params)
    assign_attributes resources_properties_params
    valid? && save
  end

  def save
    update_service_configuration.was_success
  end
  
  def new_record?
    false
  end
  
# private

  def update_service_configuration
    engines_api.update_service_configuration service_name: service_name, configurator_name: configurator_name, variables: update_service_configuration_variables_params
  end
 
  def update_service_configuration_variables_params
    {}.tap do |result|
      variables.each do |variable|
        result[variable.name] = variable.value
      end
    end
  end
 
end
