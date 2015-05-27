class GallerySettings < ActiveRecord::Base

  def default_gallery
    default_gallery_id ? Gallery.find(default_gallery_id) : Gallery.first
  end

  def self.instance
    first_or_create
  end

end