class Variable < ActiveRecord::Base

  attr_accessor(
    :name,
    :value,
    :value_confirmation,
    :label,
    :comment,
    :type,
    :regex_validator,
    :mandatory,
    :ask_at_build_time,
    :build_time_only,
    :immutable,
    :tooltip,
    :hint,
    :placeholder,
    :collection
  )

  belongs_to :variable_consumer, polymorphic: true

end
