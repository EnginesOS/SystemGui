class DesktopSettings < ActiveRecord::Base

  has_attached_file :wallpaper
  validates_attachment_content_type :wallpaper, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_wallpaper
  before_validation { wallpaper.clear if delete_wallpaper == '1' }
  before_create :set_defaults
  
  def set_defaults
    self.icon_text_color = "#ffffff"
    self.background_color = "#5481df"
  end

  def self.instance
    first_or_create
  end

end