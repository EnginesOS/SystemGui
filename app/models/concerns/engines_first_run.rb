module EnginesFirstRun

  extend EnginesApi

  def self.required?
    engines_api.first_run_required?
  end

  def self.send_parameters(params)
    engines_api.set_first_run_parameters params
    # EnginesResult.new(was_success: true, result_msg: "Something may have happened...")
  end

end