module EnginesFirstRun

  def self.required?
    # engines_api.first_run_required
    [true, false].sample
  end

  def self.set_parameters(params)
    # engines_api.set_first_run_parameters params
    EnginesResult.new(was_success: true, result_msg: "Something may have happened...")
  end

end