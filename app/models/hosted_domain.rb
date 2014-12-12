class HostedDomain < ActiveRecord::Base

  #SSL certificate fields
  attr_accessor :country
  attr_accessor :state
  attr_accessor :city
  attr_accessor :organization_name
  attr_accessor :person_name

  belongs_to :system_config

  def self.engines_api
    EnginesApiHandler.engines_api
  end

  def engines_api
    EnginesApiHandler.engines_api
  end

  def create_ssl_certificate params
    engines_api.create_ssl_certificate params
  end

  def save_via_api
    engines_api.add_self_hosted_domain(domain_name: domain_name, internal_only: internal_only).was_success
  end

  def update_via_api params
    engines_api.update_self_hosted_domain params[:old_domain_name], {domain_name: params[:domain_name], internal_only: params[:internal_only]}
  end

  def destroy_via_api
    engines_api.remove_self_hosted_domain domain_name
  end

  def validate_domain_name_not_blank
    if domain_name.blank?
      'Domain name cannot be blank.'
    else
      'OK'
    end
  end

  def self.refresh_db_and_load_all
    self.delete_all
    self.load_all_via_api
  end

  def self.load_all_via_api
    result = []
    domains = self.self_hosted_domains_hash
    domains.each do |name, params|
      domain = self.create(params)
      result << domain
    end
    return result
  end

  def self.self_hosted_domains_hash
    self.engines_api.list_self_hosted_domains
  end

end