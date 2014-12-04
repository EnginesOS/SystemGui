class AppInstallEnvVariable < ActiveRecord::Base
 
  attr_accessor(
    :build_time_only,
    :mandatory,
    :name,
    :value,
    :comment,
    :ask_at_runtime)

  has_one :app_install





  # def initialize(attributes = {})
  #   attributes.each do |name, value|
  #     send("#{name}=", value)
  #   end
  # end

end
