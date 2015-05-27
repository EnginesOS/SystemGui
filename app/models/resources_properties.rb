class ResourcesProperties < ActiveRecord::Base

  include Engines::Api

  attr_accessor :required_memory, :memory

  belongs_to :application

  # validate :sufficient_memory
  # validates :memory, presence: true

  def application_name
    application.container_name
  end

  def load
    assign_attributes(
      memory: application.memory,
      required_memory: application.blueprint_software_details["required_memory"] )
  end

  def update(resources_properties_params)
    assign_attributes resources_properties_params
    valid? && save
  end

  def save
    update_memory
  end
  
  def new_record?
    false
  end
  
private

  def sufficient_memory
    if memory.to_i < required_memory.to_i
      errors.add(:memory, "can't be less than #{required_memory}.")
    elsif memory.blank?
      errors.add(:memory, ["Memory", "is required"])
    end
  end

  def update_memory
    engines_api.set_engine_runtime_properties container_name: application_name, memory: memory
  end
 
end
