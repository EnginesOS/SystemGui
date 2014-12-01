class AppInstallEnvVariable < ActiveRecord::Base
  # include ActiveModel::Model
  # include ActiveModel::Validations
  # include ActiveModel::Conversion
  # extend ActiveModel::Naming
 
      has_one :app_install

  attr_accessor :build_time_only
  attr_accessor :mandatory

      # attr_accessor :install_id
      # attr_accessor :name
      # attr_accessor :value
      # attr_accessor :set_at_runtime

  # def initialize(attributes = {})
  #   attributes.each do |name, value|
  #     send("#{name}=", value)
  #   end
  # end

end
