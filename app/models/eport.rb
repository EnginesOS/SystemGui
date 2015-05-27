class ApplicationEport < ActiveRecord::Base

  attr_accessor(
    :name,
    :internal_port,
    :external_port,
    :protocol)

  belongs_to :software

end