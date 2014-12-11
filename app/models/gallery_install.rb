class GalleryInstall < ActiveRecord::Base

  def list_blueprints
    gallery_handler.blueprints
  end

  def gallery_handler
    @gallery_handler ||= GalleryHandler.new(url: url)
  end

  def search_blueprint_titles params
    gallery_handler.search_blueprint_titles params
  end

end
