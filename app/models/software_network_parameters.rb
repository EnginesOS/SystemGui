class SoftwareNetworkParameters < ActiveRecord::Base

  attr_accessor(
    :host_name,
    :domain_name,
    :http_protocol,
    :software_id)

  belongs_to :software

  host_name_regex = /^[A-Za-z]{2,6}$/
  validates :host_name, presence: true, format: { with: host_name_regex, :multiline => true, message: "is invalid" }
  validates_presence_of :domain_name

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