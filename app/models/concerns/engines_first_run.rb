module EnginesFirstRun

  extend EnginesApi

  def self.required?
    engines_api.first_run_required?
  end

  def self.send_parameters(params)

p "111111111111111111111111111111111111111111"
p params

    engines_api.set_first_run_parameters params
  end

end