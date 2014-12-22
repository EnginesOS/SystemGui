class SoftwareEnvironmentVariable < ActiveRecord::Base

  attr_accessor(
    :name,
    :value,
    :label,
    :comment,
    :type,
    :regexvalidator,
    :allow_multiple,
    :mandatory,
    :collection,
    :ask_at_build_time,
    :build_time_only)

  belongs_to :software

end
