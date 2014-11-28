# require "open-uri"

class AppInstall < ActiveRecord::Base

  has_attached_file :icon
  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
  has_many :app_install_env_variables
  accepts_nested_attributes_for :app_install_env_variables

  attr_accessor :delete_icon
  attr_accessor :created_from_existing_engine

  before_validation { icon.clear if delete_icon == '1' }


  def engines_api
    EnginesApiHandler.engines_api
  end 

  def self.new_from_gallery opts
    # software_definition_from_gallery = GalleryBlueprintHandler.new(opts)
    app_install = self.new(
      gallery_url: opts[:gallery_url],
      blueprint_id: opts[:blueprint_id]
    )
    blueprint_software = app_install.software_definition_from_blueprint_in_repository
    gallery_software = app_install.software_definition_from_gallery

    app_install.engine_name = gallery_software['short_name'].gsub(/[^0-9A-Za-z]/, '').downcase
    app_install.host_name = app_install.engine_name
    app_install.domain_name = SystemConfig.default_domain
    app_install.display_name = gallery_software['short_name']
    app_install.display_description = gallery_software['description']
    app_install.license_name = blueprint_software['license_name']
    app_install.license_sourceurl = blueprint_software['license_sourceurl']
    app_install.terms_and_conditions_accepted = false
    # app_install.icon = self.get_icon_from_url(gallery_software['image_url']) 
    app_install.created_from_existing_engine = false

    blueprint_software['environment_variables'].each do |ev|
      app_install.app_install_env_variables.build(ev)
    end
    return app_install
  end

  def self.new_from_engine engine_name
    engine = AppHandler.new(engine_name)
    app_install = self.new(
      engine_name: engine_name
    )

p "engine___________________________________________________________"
p engine.inspect

    app_install.host_name = engine.host_name
    app_install.domain_name = engine.domain_name
    app_install.display_name = engine.software['name']
    app_install.display_description = engine.software['description']
    app_install.license_name = engine.software['license_name']
    app_install.license_sourceurl = engine.software['license_sourceurl']
    # app_install.icon = self.get_icon_from_url(engine.software['icon_url'])
    app_install.created_from_existing_engine = true

    engine.software['environment_variables'].each do |ev|
      app_install.app_install_env_variables.build(ev)
    end

    return app_install
  end

  def attach_icon_from_gallery
    url = software_definition_from_gallery['image_url']
    begin
      @icon = URI.parse(url)
    rescue
      return nil
    end
  end

  def app
    AppHandler.new(engine_name)
  end

  def update_app_engine
p :selieeeeeeeeeeeeeeeeeeeeeeeeee
p self.inspect
    engines_api.set_engine_hostname_details engine_name: engine_name, host_name: host_name, domain_name: domain_name
  end

  def build_app


p :aaaaaaaaaaaaaaaaaaaaaaa________________________________
p repository_url_from_gallery
p app_build_opts    


    engines_api.build_engine(repository_url_from_gallery, app_build_opts)
  end

  def refresh_host_name_and_domain_name
    self.host_name = app.host_name
    self.domain_name = app.domain_name
  end

  def install_log
    response.headers['Content-Type'] = 'text/event-stream'
    begin
      follow_install_log do |line| 
        response.stream.write line
      end
    rescue IOError
    ensure
      logger.info("Killing stream")
      response.stream.close
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

  def follow_install_log
    begin
      stdin, stdout, stderr, wait_thread = Open3.popen3("tail -F -n 0 /tmp/build.out")
      stdout.each_line do |line|
        yield line
      end
    rescue IOError
    ensure
      stdin.close; stdout.close; stderr.close
      Process.kill('HUP', wait_thread[:pid])
      logger.info("Killing Tail pid: #{wait_thread[:pid]}")
    end
  end

  def app_build_opts
    {
      host_name: @host_name,
      domain_name: @domain_name,
      engine_name: @engine_name,
      gallery_url: @gallery_url,
      blueprint_id: @blueprint_id
    }
  end




end