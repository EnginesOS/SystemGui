class Software < ActiveRecord::Base

  attr_accessor :remove_all_application_data

  has_one :software_variables_handler, dependent: :destroy
  has_one :attached_services_handler, dependent: :destroy
  has_one :backup_tasks_handler, dependent: :destroy
  has_one :display, dependent: :destroy
  has_one :network, dependent: :destroy
  has_one :resource, dependent: :destroy
  has_one :install, dependent: :destroy
  has_one :docker_hub_install, dependent: :destroy
  has_many :eports

  accepts_nested_attributes_for :software_variables_handler
  accepts_nested_attributes_for :attached_services_handler
  accepts_nested_attributes_for :backup_tasks_handler
  accepts_nested_attributes_for :display
  accepts_nested_attributes_for :network
  accepts_nested_attributes_for :resource
  accepts_nested_attributes_for :install
  accepts_nested_attributes_for :docker_hub_install
  accepts_nested_attributes_for :eports

  validates :engine_name, presence: true, uniqueness: true, length: { maximum: 16 }

  def self.user_visible_applications
    all.select { |software| (
      EnginesSoftware.default_startup_state(software.engine_name) == 'running' ||
      EnginesSoftware.is_active(software.engine_name) )
      }
  end

end