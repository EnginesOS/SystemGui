class AppInstall < ActiveRecord::Base

  attr_accessor(
    :name,
    :description,
    :requiredmemory,
    :image_url,
    :langauge_name,
    :swframework_name,
    :license_name,
    :license_sourceurl,
    :host_name,
    :domain_name,
    :http_protocol,
    :memory,
    :gallery_url,
    :blueprint_id,
    :terms_and_conditions_accepted,
    :delete_icon)

  has_attached_file :icon
  has_many :app_install_env_variables
  accepts_nested_attributes_for :app_install_env_variables
  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
  before_validation { icon.clear if delete_icon == '1' }
  after_create :set_display_properties_defaults

  def engines_api
    EnginesApiHandler.engines_api
  end 

  # def self.create_empty_record
  #   # self.skip_callback(:create)
  #   self.new.save(skip_callbacks: true)
  # end

  def self.new_from_gallery params
    
    app_install = self.new(params)

    blueprint_software = app_install.software_definition_from_blueprint_in_repository
    gallery_software = app_install.software_definition_from_gallery

    app_install.engine_name ||= gallery_software['short_name'].gsub(/[^0-9A-Za-z]/, '').downcase
    app_install.host_name ||= app_install.engine_name
    app_install.domain_name ||= SystemConfig.settings.default_domain
    app_install.display_name ||= gallery_software['short_name']
    app_install.http_protocol ||= (blueprint_software['http_protocol'] || 'HTTPS and HTTP')
    app_install.display_description ||= gallery_software['description']
    app_install.license_name ||= blueprint_software['license_name']
    app_install.license_sourceurl ||= blueprint_software['license_sourceurl']
    app_install.terms_and_conditions_accepted ||= false

    blueprint_software['environment_variables'].each do |ev|
      app_install.app_install_env_variables.build(ev)
    end
    return app_install
  end

  # def self.new_from_engine engine_name
  #   engine = AppHandler.new(engine_name)
  #   app_install = self.new(
  #     engine_name: engine_name,
  #     host_name: engine.host_name,
  #     domain_name: engine.domain_name,
  #     display_name: engine.software['name'],
  #     display_description: engine.software['description'],
  #     license_name: engine.software['license_name'],
  #     license_sourceurl: engine.software['license_sourceurl'],
  #     created_from_existing_engine: true)

  #   engine.software['environment_variables'].each do |ev|
  #     app_install.app_install_env_variables.build(ev)
  #   end

  #   return app_install
  # end

  def attach_icon_using_icon_url_from_gallery
p ':attach_icon_from_icon_url_from_gallery'    
    self.icon = icon_from_url(software_definition_from_gallery['image_url'])
  end

  def icon_from_url url
p ':icon_from_url'
p url
    begin
      begin
        @icon = URI.parse(url)
      rescue Exception=>e
  p e
  p e.backtrace
  p e.mesg

      end
    rescue
      nil
    end
  end

  def app
    @app_handler ||= AppHandler.new(engine_name)
  end

  def update_display_properties params
      update(update_display_properties_params params)
  end

  def update_network_properties params
    engines_api.set_engine_hostname_properties(update_hostname_properties_params params).was_success &&
    engines_api.set_engine_network_properties(update_network_properties_params params).was_success
  end

  def update_runtime_properties params
    engines_api.set_engine_runtime_properties(update_runtime_properties_params params).was_success
  end

  def self.engine_name_not_unique params
    AppHandler.all_engine_names.include?(params[:engine_name])
  end

  def self.host_name_not_unique params
    AppHandler.all_host_names.include?(params[:host_name])
  end

  def build_app
    engines_api.build_engine(repository_url_from_gallery, app_build_params)
  end

  def set_display_properties_defaults
p ':set_display_properties_defaults'
    if self.display_name.nil?
      self.display_name = app.software['name']
      self.display_description = app.software['description']

p app.software['icon_url']
p app.software.inspect


      if app.software['icon_url'].present?
          self.icon = icon_from_url app.software['icon_url']
      end

      save
    end
  end

  def load_properties_from_engine
    self.name = app.software['name']
    self.description = app.software['description']
    self.requiredmemory = app.software['requiredmemory']
    self.image_url = app.software['icon_url']
    self.langauge_name = app.software['langauge_name']
    self.swframework_name = app.software['swframework_name']
    self.license_name = app.software['license_name']
    self.license_sourceurl = app.software['license_sourceurl']
    self.host_name = app.host_name
    self.domain_name = app.domain_name
    self.http_protocol = app.http_protocol
    self.memory = app.memory
    app_install_env_variables.delete_all
    app.software['environment_variables'].each do |ev|
      app_install_env_variables.build(ev)
    end
  end

  def blueprint_handler
    @blueprint_handler ||= GalleryBlueprintHandler.new(gallery_url: gallery_url, blueprint_id: blueprint_id)
  end

  def software_definition_from_gallery
    blueprint_handler.software_definition_from_gallery
  end

  def software_definition_from_blueprint_in_repository
    blueprint_handler.blueprint_from_repository["software"]
  end

  def repository_url_from_gallery
    blueprint_handler.repository.html_safe
  end

private

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

  def app_build_params
    {
      engine_name: engine_name,
      host_name: host_name,
      domain_name: domain_name,
      http_protocol: http_protocol,      
      gallery_url: gallery_url,
      blueprint_id: blueprint_id,
      memory: memory,
      environment_variables: environment_variables_params
    }
  end

  def environment_variables_params
    hash = {}
    app_install_env_variables.each do |ev|
      hash[ev.name] = ev.value
    end
    return hash
  end

end