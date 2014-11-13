class SettingsConfig < ActiveRecord::Base

  # attr_accessor :wallpaper_file_name
  has_attached_file :wallpaper
  validates_attachment_content_type :wallpaper, :content_type => /\Aimage\/.*\Z/

  attr_accessor :delete_wallpaper
  before_validation { wallpaper.clear if delete_wallpaper == '1' }

end