module EnginesDomain

  extend EnginesApi

  def self.create params
    engines_api.add_domain(
      domain_name: params[:domain_name],
      internal_only: params[:internal_only],
      self_hosted: params[:self_hosted])
  end

  def self.update params
    engines_api.update_domain(
      original_domain_name: params[:original_domain_name],
      domain_name: params[:domain_name],
      internal_only: params[:internal_only],
      self_hosted: params[:self_hosted])
  end

  def self.destroy params
    engines_api.remove_domain (
      { domain_name: params[:domain_name] } )
  end

  def self.create_ssl_certificate params
    engines_api.create_ssl_certificate params
  end

  def self.domains_hash
    engines_api.list_domains
  end

  def self.engines_domains
    domains_hash.keys
  end

end