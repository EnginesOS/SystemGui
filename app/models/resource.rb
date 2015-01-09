class Resource < ActiveRecord::Base

  attr_accessor(
    :required_memory,
    :memory)

  belongs_to :software

  validates :memory, numericality: { greater_than_or_equal_to: 10 }

  def load_engines_runtime
    # self.form_type = :edit_runtime
    self.memory = EnginesSoftware.memory engine_name
    self
  end

  def update_runtime params
    EnginesSoftware.update_runtime(params).was_success
  end
 
end