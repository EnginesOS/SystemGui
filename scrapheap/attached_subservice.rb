class AttachedSubservice < ActiveRecord::Base

  attr_accessor(
    :type_path,
    :publisher_namespace,
    :title,
    :description
    )

  belongs_to :attached_service
  has_many :variables, as: :variable_consumer, dependent: :destroy

  accepts_nested_attributes_for :variables

end