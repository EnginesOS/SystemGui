require "open-uri"

class AppInstall < ActiveRecord::Base

  has_attached_file :icon
  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_icon
  attr_accessor :created_from_existing_engine
  before_validation { icon.clear if delete_icon == '1' }

  has_many :app_install_env_variables
  accepts_nested_attributes_for :app_install_env_variables

  def engines_api
    EnginesApiHandler.engines_api
  end

  def self.new_with_defaults opts

    software = BlueprintHandler.new(opts).software
    app_name = software['name']
    engine_name = app_name.gsub(/[^0-9A-Za-z]/, '').downcase

    app_install = self.new(
      host_name: engine_name,
      domain_name: SystemConfig.default_domain,
      engine_name: engine_name,
      display_name: app_name,
      display_description: software['description'],
      gallery_server_name: opts[:gallery_server_name],
      gallery_server_url: opts[:gallery_server_url],
      blueprint_id: opts[:blueprint_id],
      license_name: software['license_name'],
      license_sourceurl: software['license_sourceurl'],
      terms_and_conditions_accepted: false,
      # icon: open(@image_url)
      created_from_existing_engine: false
    )

    software['environment_variables'].each do |ev|
      app_install.app_install_env_variables.build(ev)
    end

    return app_install
  end

  def self.new_from_engine engine_name

    engine = AppHandler.new(engine_name)
    blueprint = engine.blueprint
    software = blueprint['software']
    icon_url = software['icon_url']

    app_install = self.new(
      host_name: engine.host_name,
      domain_name: engine.domain_name,
      engine_name: engine_name,
      display_name: software['name'],
      display_description: software['description'],
      license_name: software['license_name'],
      license_sourceurl: software['license_sourceurl'],
      # terms_and_conditions_accepted: true,
      # icon: (open(icon_url) if icon_url),
      created_from_existing_engine: true
    )

    software['environment_variables'].each do |ev|
      app_install.app_install_env_variables.build(ev)
    end

    return app_install
  end

  def app
    AppHandler.new(engine_name)
  end

  def update_app_engine
    app.update_engine
  end

  def refresh_host_name_and_domain_name
    self.host_name = app.host_name
    self.domain_name = app.domain_name
    # self.save
  end

  def build_app
p :llllllllllllllllllllllllll
p repository
p :mmmmmmmmmmmmmmmmmmmmmmm
p app_build_opts
    engines_api.build_engine(repository.html_safe, app_build_opts)
  end

  def repository
    gallery = EngineGallery.getGallery(gallery_server_name, gallery_server_url)
    gallery.get_repository(blueprint_id)
  end

  def app_build_opts
    {
      host_name: host_name,
      domain_name: domain_name,
      engine_name: engine_name,
      gallery_server_name: gallery_server_name,
      gallery_server_url: gallery_server_url,
      blueprint_id: blueprint_id
    }
  end


end



