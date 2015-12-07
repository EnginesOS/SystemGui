class DomainDefaultName # < ActiveRecord::Base

  include ActiveModel::Model
  include ActiveModel::Validations
  extend Engines::Api

  attr_accessor :default_domain, :engines_api_error

  validates :default_domain, presence: true

  def self.load
    new(default_domain: engines_default_domain)
  end

  def update
    valid? && update_default_domain
  end

  def self.engines_default_domain
    engines_api.get_default_domain
  end

  def update_default_domain
    result = self.class.engines_api.set_default_domain(default_domain: default_domain)
    if !result.was_success
      @engines_api_error = [ @engines_api_error.to_s, "Unable to update domain.",
                            (result.result_mesg.present? ? result.result_mesg : "No result message given by engines api."),
                            "Called 'update_default_domain' with default_domain: #{default_domain}" ].join(' ')
    end
    result.was_success
  end

  def new_record?
    false
  end

end
