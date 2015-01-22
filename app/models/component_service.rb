class ComponentService < ActiveRecord::Base

  has_many :variables, as: :variable_consumer, dependent: :destroy
  belongs_to :component

  accepts_nested_attributes_for :variables

end