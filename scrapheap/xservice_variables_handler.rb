class ServiceVariablesHandler < ActiveRecord::Base

  has_many :variables, as: :variable_consumer, dependent: :destroy
  belongs_to :service

  accepts_nested_attributes_for :variables

  def load_service_variables_from_api
    variables.clear
    variables.build( params_from_api_data )
    # self
  end

  def save_to_api
    EnginesSoftware.update_variables(params_for_api_update).was_success
  end

private

  def params_from_api_data
    EnginesSoftware.software_variables(software.engine_name)
  end

  def params_for_api_update
    {
      engine_name: software.engine_name,
      environment_variables:
        variables.map do |variable|
          {
            name: variable.name,
            value: variable.value
          }
        end
    }
  end

end