class Domain < ActiveRecord::Base

  attr_accessor :original_domain_name
  attr_accessor :country
  attr_accessor :state
  attr_accessor :city
  attr_accessor :organization_name
  attr_accessor :person_name

  validates_presence_of :domain_name

  def update_via_api
    EnginesDomain.update(
      original_domain_name: original_domain_name,
      domain_name: domain_name,
      internal_only: internal_only,
      self_hosted: self_hosted)
  end

  def save_via_api
    EnginesDomain.create(
      domain_name: domain_name,
      internal_only: internal_only,
      self_hosted: self_hosted)
  end

  def destroy_via_api
    EnginesDomain.destroy(
      domain_name: domain_name)
  end

end