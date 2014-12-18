class SoftwareEnvironmentVariable < ActiveRecord::Base
  has_no_table

  include ActiveModel::Model
  # include ActiveModel::Associations
 
  attr_accessor(
    :software_id,
    :name,
    :label,
    :comment,
    :type,
    :regexvalidator,
    :allow_multiple,
    :mandatory,
    :collection,
    :ask_at_build_time,
    :build_time_only)

    # :value,
    # 

  belongs_to :software
  has_many :software_environment_variable_values
  accepts_nested_attributes_for :software_environment_variable_values

  # def populate_env_variable_value value
  #   env_variable_values.build(value: value)
  # end

end
