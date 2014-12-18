module EnginesSettings

  extend EnginesApi

  def self.update_engines settings_params
    engines_api.save_system_preferences settings_params
  end

end