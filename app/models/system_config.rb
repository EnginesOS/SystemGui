class SystemConfig < ActiveRecord::Base

  # attr_accessor :wallpaper_file_name
  has_attached_file :wallpaper
  validates_attachment_content_type :wallpaper, :content_type => /\Aimage\/.*\Z/

  attr_accessor :delete_wallpaper
  before_validation { wallpaper.clear if delete_wallpaper == '1' }

  def self.settings
    self.first || self.new
  end

  def self.default_domain
    record = self.first
    if record.nil?
      return nil
    else
      self.first.default_domain
    end
  end

end