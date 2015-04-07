class AttachedService < ActiveRecord::Base

  attr_accessor(
    :title,
    :service_handle,
    :description,
    :type_path,
    :publisher_namespace,
    :persistant,
    :create_type,
    :parent_engine_name,
    :wizard_create_type,
    :wizard_orphan_parent_name,
    :wizard_active_service_handle)

  belongs_to :attached_services_handler
  has_many :variables, as: :variable_consumer, dependent: :destroy
  has_many :attached_subservices, dependent: :destroy

  accepts_nested_attributes_for :variables
  accepts_nested_attributes_for :attached_subservices


  def attachable_active_attached_services
    EnginesAttachedService.active_attached_services(type_path, publisher_namespace)
  rescue
    ["needs", "a method", "to call"]
  end

  def attachable_orphaned_attached_services
    EnginesAttachedService.orphaned_services(type_path, publisher_namespace)
  rescue
    ["also needs", "a method", "to call"]
  end


end

