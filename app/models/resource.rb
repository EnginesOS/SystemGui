class Resource < ActiveRecord::Base

  attr_accessor(
    :required_memory,
    :memory)

  belongs_to :software

  validate :sufficient_memory

  def save_to_api
    EnginesSoftware.update_resources(params_for_api_update)
  end

private

  def sufficient_memory
    if memory.to_i < required_memory.to_i
      errors.add(:memory, "can't be less than #{required_memory}.")
    elsif memory.blank?
      errors.add(:memory, ["Memory", "is required"])
    end
  end

  def params_for_api_update
    {
      engine_name: software.engine_name,
      memory: memory
    }
  end

  def self.api_data_for engine_name
    {
      memory: EnginesSoftware.memory(engine_name),
      required_memory: EnginesSoftware.blueprint_software_details(engine_name)["requiredmemory"]
    }
  end
 
end