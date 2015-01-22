class Software < ActiveRecord::Base

  has_many :attached_services, as: :attached_service_consumer, dependent: :destroy
  has_one :software_variable, dependent: :destroy
  has_one :display, dependent: :destroy
  has_one :network, dependent: :destroy
  has_one :resource, dependent: :destroy
  has_one :install, dependent: :destroy

  accepts_nested_attributes_for :software_variable
  accepts_nested_attributes_for :attached_services
  accepts_nested_attributes_for :display
  accepts_nested_attributes_for :network
  accepts_nested_attributes_for :resource
  accepts_nested_attributes_for :install

  validates :engine_name, uniqueness: true

  def self.user_visible_applications
    all.select { |software| EnginesSoftware.default_startup_state(software.engine_name) == 'running' }
  end

end