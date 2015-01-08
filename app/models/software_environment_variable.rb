class SoftwareEnvironmentVariable < ActiveRecord::Base

  attr_accessor(
    :name,
    :value,
    :label,
    :comment,
    :type,
    :regex_validator,
    # :allow_multiple,
    :mandatory,
    :collection,
    :ask_at_build_time,
    :build_time_only,
    :immutable)

  belongs_to :software


  def load_engines_software_environment_variables
    self.form_type = :edit_software_variables
    software_environment_variables.delete_all
p :EnginesSoftware_environment_variables
p EnginesSoftware.environment_variables(engine_name)

    self.software_environment_variables_attributes = EnginesSoftware.environment_variables(engine_name)
    self
  end

  # environment variables update is handled by the same method as update runtime properties
  def update_software_variables params
    EnginesSoftware.update_runtime_properties(params).was_success
  end


end
