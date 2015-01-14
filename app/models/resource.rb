class Resource < ActiveRecord::Base

  attr_accessor(
    :required_memory,
    :memory)

  belongs_to :software

  validate :sufficient_memory

  def load_from_api
    self.memory = EnginesSoftware.memory software.engine_name
    self.required_memory = EnginesSoftware.blueprint_software_details(software.engine_name)["requiredmemory"]
    self
  end

  def save_to_api
    return false if !save
    EnginesSoftware.update_resources(params_for_api_update).was_success
  end

private

  def sufficient_memory
    if memory.to_i < required_memory.to_i
      errors.add(:memory, "can't be less than #{required_memory}.")
    end
  end

  def params_for_api_update
    {
      engine_name: software.engine_name,
      memory: memory
    }
  end

 
end