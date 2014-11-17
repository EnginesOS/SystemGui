class AppInstall < ActiveRecord::Base

  has_many :app_install_env_variables
  accepts_nested_attributes_for :app_install_env_variables

  def self.find_by_container_name container_name
    self.find_by container_name: container_name
  end

end



