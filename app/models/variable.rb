class Variable < ActiveRecord::Base

  attr_accessor(
    :name,
    :value,
    :label,
    :comment,
    :type,
    :regex_validator,
    :mandatory,
    :collection,
    :ask_at_build_time,
    :build_time_only,
    :immutable)

  belongs_to :software

  def self.save_to_api params
    EnginesSoftware.update_variables(params).was_success
  end

  def self.params_from_api engine_name
    EnginesSoftware.environment_variables(engine_name)
  end

end
