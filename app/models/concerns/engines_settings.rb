module EnginesSettings

  extend EnginesApi

  def self.update_engines settings_params
    engines_api.save_system_preferences settings_params
  end

  def self.smtp_auth_types
    engines_api.get_available_smtp_auth_types
  end

end