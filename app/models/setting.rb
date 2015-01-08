class Setting < ActiveRecord::Base

  has_attached_file :wallpaper
  validates_attachment_content_type :wallpaper, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_wallpaper
  before_validation { wallpaper.clear if delete_wallpaper == '1' }

  # has_many :domains
  # accepts_nested_attributes_for :domains

  def update_engines settings_params
    Domain.update_engines settings_params
  end

  # def self.settings
  #   settings = self.first
  #   if settings.nil?
  #     settings = self.new
  #     settings.save
  #   end
  #   return settings
  # end

  # def self.settings
  #   settings = self.settings_from_db
  #   Domain.self_hosted_domains_hash.each do |name, params|
  #     settings.domains.build(params)
  #   end
  #   return settings
  # end

end