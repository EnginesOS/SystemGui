class Software < ActiveRecord::Base

  has_many :variables, dependent: :destroy
  has_one :display, dependent: :destroy
  has_one :network, dependent: :destroy
  has_one :resource, dependent: :destroy
  has_one :install, dependent: :destroy

  accepts_nested_attributes_for :variables
  accepts_nested_attributes_for :display
  accepts_nested_attributes_for :network
  accepts_nested_attributes_for :resource
  accepts_nested_attributes_for :install

  def self.user_visible_applications
    all.select { |software| EnginesSoftware.state_as_set_by_user(software.engine_name) == 'running' }
  end

  def load_variables_from_api
    variables.destroy_all
    environment_variable_params = EnginesSoftware.environment_variables(engine_name)
    variables.create environment_variable_params
    self
  end

  def save_variables_to_api
    Variable.save_to_api(variables_params)
  end

  def variables_params
    {
      engine_name: engine_name,
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