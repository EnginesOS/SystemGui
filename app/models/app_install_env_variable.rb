class AppInstallEnvVariable < ActiveRecord::Base
 
  attr_accessor(
    :name,
    :value,
    :label,
    :comment,
    :build_time_only,
    :mandatory,
    :ask_at_build_time)

  has_one :app_install





  # def initialize(attributes = {})
  #   attributes.each do |name, value|
  #     send("#{name}=", value)
  #   end
  # end

end
