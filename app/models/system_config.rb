class SystemConfig < ActiveRecord::Base

  has_attached_file :wallpaper
  validates_attachment_content_type :wallpaper, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_wallpaper
  before_validation { wallpaper.clear if delete_wallpaper == '1' }

  has_many :hosted_domains
  accepts_nested_attributes_for :hosted_domains

  def self.engines_api
    EnginesApiHandler.engines_api
  end

  def engines_api
    EnginesApiHandler.engines_api
  end

  def self.settings_from_db
    settings = self.first
    if settings.nil?
      settings = self.new
      settings.save
    end
    return settings
  end

  def self.settings
    settings = self.settings_from_db
    HostedDomain.self_hosted_domains_hash.each do |name, params|
      settings.hosted_domains.build(params)
    end
    return settings
  end

end