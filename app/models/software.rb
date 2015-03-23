class Software < ActiveRecord::Base

  attr_accessor :remove_all_application_data

  has_one :software_variables_handler, dependent: :destroy
  has_one :attached_services_handler, dependent: :destroy
  has_one :display, dependent: :destroy
  has_one :network, dependent: :destroy
  has_one :resource, dependent: :destroy
  has_one :install, dependent: :destroy

  accepts_nested_attributes_for :software_variables_handler
  accepts_nested_attributes_for :attached_services_handler
  accepts_nested_attributes_for :display
  accepts_nested_attributes_for :network
  accepts_nested_attributes_for :resource
  accepts_nested_attributes_for :install

  validates :engine_name, presence: true, uniqueness: true, length: { maximum: 16 }

  def self.user_visible_applications
    all.select { |software| EnginesSoftware.default_startup_state(software.engine_name) == 'running' }
  end

  def backup_tasks
    @backup_tasks ||= EnginesSoftware.backup_tasks engine_name
  end

  def volumes
    @volumes ||= EnginesSoftware.volumes engine_name
  end

  def persistant_services
    @persistant_services ||= EnginesSoftware.persistant_services engine_name
  end

end