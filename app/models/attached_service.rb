class AttachedService < ActiveRecord::Base

  attr_accessor(
    :title,
    :service_type)

  belongs_to :attached_services_handler
  has_many :variables, as: :variable_consumer, dependent: :destroy
  has_many :attached_subservices, dependent: :destroy

  accepts_nested_attributes_for :variables
  accepts_nested_attributes_for :attached_subservices

  def available_subservices
    EnginesSoftware.available_services(software.engine_name, service_type)
  end

end