class Domain < ActiveRecord::Base

  attr_accessor :old_domain_name
  attr_accessor :country
  attr_accessor :state
  attr_accessor :city
  attr_accessor :organization_name
  attr_accessor :person_name

  # belongs_to :system_config

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
    EnginesDomain.engines_domains.map { |domain_params| create domain_params }
  end

  def save_via_api
    EnginesDomain.add_self_hosted_domain(
      domain_name: domain_name,
      internal_only: internal_only,
      self_hosted: self_hosted)
  end

end