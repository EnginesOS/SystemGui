module EnginesInstaller

  extend EnginesApi

  def self.build_engine (engine_build_params)
    engines_api.build_engine engine_build_params
  end

  def self.generate_next_unique_engine_name_for(engine_name)
    existing_engine_names = EnginesSoftware.all_engine_names
    unique_engine_name_candidate = engine_name
    index = 2
    while existing_engine_names.include? unique_engine_name_candidate do
      unique_engine_name_candidate = engine_name + index.to_s
      index += 1
    end
    unique_engine_name_candidate
  end

  def self.generate_next_unique_host_name_for(host_name)
    host_name = host_name.sub('-', '')
    existing_host_names = EnginesSoftware.all_host_names
    unique_host_name_candidate = host_name
    index = 2
    while existing_host_names.include? unique_host_name_candidate do
      unique_host_name_candidate = host_name + index.to_s
      index += 1
    end
    unique_host_name_candidate
  end

  def self.engine_name_is_unique? engine_name
    EnginesSoftware.all_engine_names.exclude?(engine_name)
  end

  def self.fqdn_is_unique? fqdn
    EnginesSoftware.all_fqdns.exclude?(fqdn)
  end

  # def self.software_variable_passwords_not_confimed?(params)
  #   params.each do |k,v|
  #     if v["type"] == "password_with_confirmation"
  #       if v["value"] != v["password_confirmation"]
  #         next
  #       else
  #         return false
  #       end
  #     end
  #   end
  # end

end