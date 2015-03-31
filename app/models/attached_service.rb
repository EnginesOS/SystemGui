class AttachedService < ActiveRecord::Base

  attr_accessor(
    :title,
    :service_handle,
    :description,
    :type_path,
    :publisher_namespace,
    :persistant,
    :create_type)

  belongs_to :attached_services_handler
  has_many :variables, as: :variable_consumer, dependent: :destroy
  has_many :attached_subservices, dependent: :destroy

  accepts_nested_attributes_for :variables
  accepts_nested_attributes_for :attached_subservices

  # def reload_from_api(service_type, service_provider)
    
  # end

end

