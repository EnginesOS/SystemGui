class DisplaySettings < ActiveRecord::Base

  has_attached_file :wallpaper
  validates_attachment_content_type :wallpaper, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_wallpaper
  before_validation { wallpaper.clear if delete_wallpaper == '1' }

  has_attached_file :icon, styles: { default: "32x32>" }
  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_icon
  before_validation { icon.clear if delete_icon == '1' }

  before_create :set_defaults

  def set_defaults
    self.icon_text_color = "#ffffff"
    self.background_color = "#5481df"
    self.system_title = "#{System.system_hostname.to_s.humanize} Engines".strip
    self.show_desktop_icon = true
    self.show_desktop_signin = true
  end

  def self.instance
    first_or_create
  end

end
