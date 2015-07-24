class DomainSettings < ActiveRecord::Base

  extend Engines::Api

  attr_accessor :default_domain, :default_site, :engines_api_error

  validates :default_domain, :default_site, presence: true

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
    engines_api.get_default_domain
  end

  def self.engines_default_site
    engines_api.get_default_site
  end

  def update_default_domain
    result = self.class.engines_api.set_default_domain(default_domain: default_domain)
    if !result.was_success
      @engines_api_error = @engines_api_error.to_s + (result.result_mesg.present? ? result.result_mesg : "Unable to update domain. No result message given by engines api. Called 'update_default_domain' with default_domain: #{default_domain}")
    end
    result.was_success
  end

  def update_default_site
    result = self.class.engines_api.set_default_site(default_site_url: default_site)
    if !result.was_success
      @engines_api_error = @engines_api_error.to_s + (result.result_mesg.present? ? result.result_mesg : "Unable to update default site. No result message given by engines api. Called 'set_default_site' with default_site: #{default_site}")
    end
    result.was_success
  end
  
  def new_record?
    false
  end

end