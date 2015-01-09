module EnginesInstaller

  extend EnginesApi

  def self.install_engines_software(software_params)
    engines_api.build_engine software_params
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

  def self.engine_name_not_unique? engine_name
    EnginesSoftware.all_engine_names.include?(engine_name)
  end

  def self.fqdn_not_unique? fqdn
    EnginesSoftware.all_fqdns.include?(fqdn)
  end

  def self.software_variable_passwords_not_confimed?(params)
    params.each do |k,v|
      if v["type"] == "password_with_confirmation"
        if v["value"] != v["password_confirmation"]
          next
        else
          return false
        end
      end
    end
  end

end