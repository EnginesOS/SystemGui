class ServiceAction < ActiveRecord::Base

  include Engines::Api

  attr_accessor :service, :name, :return_type, :return_file_name, :label, :description, :action_result, :engines_api_error

  has_many :variables, as: :variable_consumer, dependent: :destroy
  accepts_nested_attributes_for :variables

  def load
    assign_attributes(service.actionator_params_for name)
    self
  end

  def perform_action
    result = engines_api.perform_service_action(service.container_name, name, update_service_action_variables_params)
    if result.is_a? EnginesOSapiResult
      @engines_api_error = "Unable perform action. " +
                            (result.result_mesg.present? ? result.result_mesg : "Called 'perform_service_action'. No result message given by engines api.")
      false
    else
      @action_result = result
      true
    end
  end

  def new_record?
    true
  end

  def perform_service_action_params
    { service_name: service.container_name, actionator_name: name, variables: update_service_action_variables_params }
  end

  def update_service_action_variables_params
    {}.tap do |result|
      variables.each do |variable|
        result[variable.name.to_sym] = variable.value
      end
    end
  end

end
