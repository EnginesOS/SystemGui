class Network < ActiveRecord::Base

  attr_accessor(
    :host_name,
    :domain_name,
    :http_protocol)

  belongs_to :software

  host_name_regex = /^[A-Za-z0-9]*$/
  validates :host_name, {presence: true, format: { with: host_name_regex, multiline: true, 
      message: "is invalid. Please use character a-z and 0-9." },
    length: {minimum: 2, maximum: 50}}
  validates_presence_of :domain_name
  validate :fqdn_is_unique_on_update?, on: :update
  validate :fqdn_is_unique?, on: :create

  def load_from_api
    self.host_name = EnginesSoftware.host_name software.engine_name
    self.domain_name = EnginesSoftware.domain_name software.engine_name
    self.http_protocol = EnginesSoftware.http_protocol software.engine_name
    self
  end

  def save_to_api
    return false if !save

    result = EnginesSoftware.update_host_name(params_for_api_update)
    if result.was_success == false
      errors.add(:base, result.result_mesg)
      return false
    end

    result = EnginesSoftware.update_domain_name(params_for_api_update)
    if result.was_success == false
      errors.add(:base, result.result_mesg)
      return false
    else
      return true
    end

  end

  def self.best_default_domain
    Setting.first_or_create.default_domain || EnginesDomain.engines_domains.first
  end

  def self.best_http_protocol protocol
    ['HTTPS only', 'HTTP only', 'HTTPS and HTTP'].include?(protocol) ? protocol : 'HTTPS and HTTP'
  end

private

  # def load_from_params params
  #   self.host_name = params[:host_name]
  #   self.domain_name = params[:domain_name]
  #   self.http_protocol = params[:http_protocol]
  #   self
  # end

  def params_for_api_update
    {
      engine_name: software.engine_name,
      host_name: host_name,
      domain_name: domain_name,
      http_protocol: http_protocol
    }
  end

  def fqdn_is_unique_on_update?
    return true if fqdn_unchanged?
    fqdn_is_unique?
  end

  def fqdn_is_unique?
    if EnginesInstaller.fqdn_is_unique? (host_name + '.' + domain_name)
      true
    else
      errors.add(:base, 'The combination of host name plus domain name must be unique.')
    end
  end

  def fqdn_unchanged?
    EnginesSoftware.fqdn(software.engine_name) == (host_name.to_s + '.' + domain_name.to_s)
  end
  
end