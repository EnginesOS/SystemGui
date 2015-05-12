class DomainSettings < ActiveRecord::Base

  extend Engines::Api

  attr_accessor :default_domain, :default_site

  validate :default_domain, :default_site, presence: true

  def self.load
    new(
      default_domain: engines_default_domain,
      default_site: engines_default_site)
  end

  def update
    valid? && update_domain_settings
  end

  def update_domain_settings
    update_default_domain && update_default_site
  end

  def self.engines_default_domain
    @engines_default_domain ||= engines_api.get_default_domain
  end

  def self.engines_default_site
    @engines_default_site ||= engines_api.get_default_site
  end

  def update_default_domain
    self.class.engines_default_domain == default_domain ||
    self.class.engines_api.set_default_domain(default_domain: default_domain).was_success
  end

  def update_default_site
    self.class.engines_default_site == default_site ||
    self.class.engines_api.set_default_site(default_site: default_site).was_success
  end
  
  def new_record?
    false
  end

end