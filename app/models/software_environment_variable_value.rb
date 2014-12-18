class SoftwareEnvironmentVariableValue < ActiveRecord::Base
  has_no_table

  include ActiveModel::Model
  # include ActiveModel::Associations

  attr_accessor(
    :software_environment_variable_id,
    :value)

  belongs_to :software_environment_variable

end
