class Domain < ActiveRecord::Base

  attr_accessor :original_domain_name
  attr_accessor :country
  attr_accessor :state
  attr_accessor :city
  attr_accessor :organization_name
  attr_accessor :person_name
  attr_accessor :domain_name
  attr_accessor :internal_only
  attr_accessor :self_hosted

  domain_name_regex = /^([a-zA-Z0-9][-a-zA-Z0-9]*[a-zA-Z0-9]\.)+([a-zA-Z0-9]{2,5})$/
  validates :domain_name, presence: true, format: { with: domain_name_regex, :multiline => true  }

  def api_save
    result = EnginesDomain.update(
      original_domain_name: original_domain_name,
      domain_name: domain_name,
      internal_only: internal_only,
      self_hosted: self_hosted)
    if result.was_success == false
      errors.add(:base, result.result_mesg)
      return false
    else
      return true
    end
  end

  def api_create
    result = EnginesDomain.create(
      domain_name: domain_name,
      internal_only: internal_only,
      self_hosted: self_hosted)
    if result.was_success == false
      errors.add(:base, result.result_mesg)
      return false
    else
      return true
    end
  end

  def api_destroy
    EnginesDomain.destroy(
      domain_name: domain_name)
  end

end