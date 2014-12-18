module EnginesDomain

  extend EnginesApi

  def self.create params
    engines_api.add_self_hosted_domain domain_name: params[:domain_name], internal_only: params[:internal_only]
  end

  def self.update params
    engines_api.update_self_hosted_domain params[:old_domain_name], domain_name: params[:domain_name], internal_only: params[:internal_only]
  end

  def self.destroy domain_name
    engines_api.remove_self_hosted_domain domain_name
  end

  def self.create_ssl_certificate params
    engines_api.create_ssl_certificate params
  end

  def self.self_hosted_domains_hash
    engines_api.list_self_hosted_domains
  end

  def self.engines_domains
    self_hosted_domains_hash.values
  end

end