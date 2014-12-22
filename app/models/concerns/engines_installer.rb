module EnginesInstaller

  extend EnginesApi

  def self.install_engines_software software_params
    repository_url = software_params[:repository_url]
    software_params.delete(:repository_url)
    build_engine repository_url, software_params
  end

  def self.generate_next_unique_engine_name_for engine_name
    existing_engine_names = EnginesSoftware.all_engine_names
    unique_engine_name_candidate = engine_name
    index = 2
    while existing_engine_names.include? unique_engine_name_candidate do
      unique_engine_name_candidate = engine_name + index.to_s
      index += 1
    end
    unique_engine_name_candidate
  end

  def self.generate_next_unique_host_name_for host_name
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

  def self.host_name_not_unique? host_name
    EnginesSoftware.all_host_names.include?(host_name)
  end

private

  def self.build_engine repository_url_from_gallery, software_params
    engines_api.build_engine(repository_url_from_gallery, software_params)
  end

end