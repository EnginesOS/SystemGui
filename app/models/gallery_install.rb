class GalleryInstall < ActiveRecord::Base

  def list_blueprints
    GalleryHandler.new(url: url).list_blueprints
  end

end
