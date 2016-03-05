class ServiceConfiguration < ActiveRecord::Base

  include Engines::Api

  attr_accessor :service, :name, :no_save, :label, :description, :engines_api_error

  has_many :variables, as: :variable_consumer, dependent: :destroy
  accepts_nested_attributes_for :variables

  def load
    assign_attributes(service.configurator_params_for name)
    self
  end

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

  # def variable_values
  #   @variable_values ||= @service.service_configuration_variables_for(name)
  # end

  def update_service_configuration_params
    { service_name: service.container_name, configurator_name: name, variables: update_service_configuration_variables_params }
  end

  def update_service_configuration_variables_params
    {}.tap do |result|
      variables.each do |variable|
        result[variable.name.to_sym] = variable.value
      end
    end
  end

end
