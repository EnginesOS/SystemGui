class Setting < ActiveRecord::Base

  has_attached_file :wallpaper
  validates_attachment_content_type :wallpaper, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_wallpaper
  before_validation { wallpaper.clear if delete_wallpaper == '1' }

  def update_engines settings_params
    EnginesSettings.update_engines settings_params
  end

end