class BlueprintHandler

  def initialize opts
p opts
    @blueprint_id = opts[:blueprint_id]
    @gallery_server_name = opts[:gallery_server_name]
    @gallery_server_url = opts[:gallery_server_url]
    @engine_name = opts[:engine_name]
    @app_install_created_from_existing_engine = opts[:created_from_existing_engine]
  end

  def gallery
    EngineGallery.getGallery @gallery_server_name, @gallery_server_url
    # GalleryHandler.get_gallery @gallery_server_name, @gallery_server_url
  end

# p :qqqqqqqqqqqqqqq
# p opts
# p @gallery_server_name
# p @gallery_server_url

  def blueprint
    if @app_install_created_from_existing_engine
      AppHandler.new(@engine_name).blueprint
    else
      gallery.get_blueprint @blueprint_id
    end
  end

  def software
    blueprint['software']
  end

end