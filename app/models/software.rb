class Software < ActiveRecord::Base

  attr_accessor(
    :repository_url, 
    # :name,
    # :description,
    :requiredmemory,
    :default_image_url,
    :langauge_name,
    :swframework_name,
    :license_name,
    :license_sourceurl,
    :host_name,
    :domain_name,
    :http_protocol,
    :memory,
    :gallery_url,
    :software_id,
    :terms_and_conditions_accepted,
    :delete_icon)

  has_attached_file :icon, dependent: :destroy
  has_many :software_environment_variables, dependent: :destroy

  accepts_nested_attributes_for :software_environment_variables

  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
  before_validation { icon.clear if delete_icon == '1' }

  def load_display_property_defaults
    engines_software_details = EnginesSoftware.blueprint_software_details(engine_name)
    self.display_name = engines_software_details['name']
    self.display_description = engines_software_details['description']
    self.icon = EnginesUtilities.icon_from_url(engines_software_details['icon_url'])
    self
  end

  def load_engines_software_network_parameters
    self.host_name = EnginesSoftware.host_name engine_name
    self.domain_name = EnginesSoftware.http_protocol engine_name
    self.http_protocol = EnginesSoftware.domain_name engine_name
    self
  end

  def load_engines_software_runtime_parameters
    software_environment_variables.delete_all
    self.memory = EnginesSoftware.memory engine_name
    self.software_environment_variables_attributes = EnginesSoftware.environment_variables(engine_name)
    self
  end

  def self.new_from_repository gallery_software_params
    new(new_software_params gallery_software_params)
  end

  def attach_default_icon
    self.icon = EnginesUtilities.icon_from_url default_image_url
  end

  def update_display_properties params
    update update_display_properties_params params
  end

  def update_network_properties params
    EnginesSoftware.update_hostname_properties(update_hostname_properties_params params).was_success &&
    EnginesSoftware.update_network_properties(update_network_properties_params params).was_success
  end

  def update_runtime_properties params
    EnginesSoftware.update_runtime_properties(update_runtime_properties_params params).was_success
  end

  def self.user_visible_applications
    all.select { |software| EnginesSoftware.state_as_set_by_user(software.engine_name) == 'running' }
  end

private

  def self.new_software_params gallery_software_params
    repository_url = EnginesGallery.software(gallery_software_params)["repository"]
    repository_software_params = EnginesRepository.software_params repository_url: repository_url
    software_name = repository_software_params['name'].gsub(/[^0-9A-Za-z]/, '').downcase
    {
      repository_url: repository_url,
      display_name: repository_software_params['name'],
      display_description: repository_software_params['description'],
      engine_name: EnginesInstaller.generate_next_unique_engine_name_for(software_name),
      host_name: EnginesInstaller.generate_next_unique_host_name_for(software_name),
      domain_name: Setting.first_or_create.default_domain,
      http_protocol: (repository_software_params['http_protocol'] || 'HTTPS and HTTP'),      
      gallery_url: gallery_software_params[:gallery_url],
      software_id: gallery_software_params[:software_id],
      memory: repository_software_params['memory'],
      default_image_url: repository_software_params['icon_url'],
      license_name: repository_software_params['license_name'],
      license_sourceurl: repository_software_params['license_sourceurl'],
      software_environment_variables_attributes: repository_software_params["environment_variables"]
    }
  end

  def update_display_properties_params params
    {
      display_name: params[:display_name],
      display_description: params[:display_description],
      icon: params[:icon]
    }
  end

  def update_hostname_properties_params params
    {
      engine_name: engine_name,
      host_name: params[:host_name],
      domain_name: params[:domain_name],
    }
  end

  def update_network_properties_params params
    {
      engine_name: engine_name,
      http_protocol: params[:http_protocol]
    }
  end

  def update_runtime_properties_params params
    {
      engine_name: engine_name,
      memory: params[:memory],
      environment_variables: params[:environment_variables_params]
    }
  end

end