class ServiceConfiguration < ActiveRecord::Base

  include Engines::Api

  attr_accessor :service_name, :name, :label, :description, :engines_api_error
  
  # belongs_to :service
  
  has_many :variables, as: :variable_consumer, dependent: :destroy
  accepts_nested_attributes_for :variables

  # def load
    # load_variable_configurations && load_variable_values
    # self
  # end
# 
  # def load_variable_configurations
    # service.configurators_hash[configurator_name.to_sym][:params].values.each do |configuration|
      # variables.build(configuration)
    # end
  # end
# 
  # def load_variable_values
    # variables.each do |variable|
      # if variable_values.present? && variable_values[variable.name.to_sym].present?
        # variable.value = variable_values[variable.name.to_sym]
      # end
    # end
  # end
# 
  # def service
    # @service = Service.where(container_name: service_name).new
  # end

  def persist!
    valid? && save
  end

  def save
    result = engines_api.update_service_configuration(update_service_configuration_params)
    if !result.was_success
      @engines_api_error = "Unable to configure service. " + 
                            "Called 'update_service_configuration' with params :service_name :configurator_name :variables. " +
                            (result.result_mesg.present? ? result.result_mesg : "No result message given by engines api.")
    end
    result.was_success
  end
  
  def new_record?
    false
  end
  
# private
 
  def variable_values
    @variable_values ||= @service.service_configuration_variables_for(name)
  end
  
  def update_service_configuration_params
    { service_name: service_name, configurator_name: name, variables: update_service_configuration_variables_params }
  end
  
  def update_service_configuration_variables_params
    {}.tap do |result|
      variables.each do |variable|
        result[variable.name.to_sym] = variable.value
      end
    end
  end
 
end
