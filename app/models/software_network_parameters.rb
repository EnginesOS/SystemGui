class SoftwareNetworkParameters < ActiveRecord::Base

  attr_accessor(
    :host_name,
    :domain_name,
    :http_protocol,
    :software_id)

  belongs_to :software

  validates_presence_of :domain_name
  domain_name_regex = /^(([a-zA-Z]{1})|([a-zA-Z]{1}[a-zA-Z]{1})|([a-zA-Z]{1}[0-9]{1})|([0-9]{1}[a-zA-Z]{1})|([a-zA-Z0-9][a-zA-Z0-9-_]{1,61}[a-zA-Z0-9]))\.([a-zA-Z]{2,6}|[a-zA-Z0-9-]{2,30}\.[a-zA-Z]{2,3})$/
  validates :domain_name, format: { with: domain_name_regex, :multiline => true  }

  validates_presence_of :host_name
  host_name_regex = /^(?=.{1,255}$)[0-9A-Za-z](?:(?:[0-9A-Za-z]|-){0,61}[0-9A-Za-z])?(?:\.[0-9A-Za-z](?:(?:[0-9A-Za-z]|-){0,61}[0-9A-Za-z])?)*\.?$/
  validates :host_name, format: { with: host_name_regex, :multiline => true, message: "is invalid" }

  def load_engines_software_network_parameters
    self.form_type = :edit_network_properties
    self.host_name = EnginesSoftware.host_name engine_name
    self.domain_name = EnginesSoftware.domain_name engine_name
    self.http_protocol = EnginesSoftware.http_protocol engine_name
    self
  end

  def update_network_properties params
    EnginesSoftware.update_hostname_properties(params).was_success &&
    EnginesSoftware.update_network_properties(params).was_success
  end

  def self.best_default_domain
    Setting.first_or_create.default_domain || EnginesDomain.engines_domains.first
  end

  def self.best_http_protocol protocol
    ['HTTPS only', 'HTTP only', 'HTTPS and HTTP'].include?(protocol) ? protocol : 'HTTPS and HTTP'
  end
  
end