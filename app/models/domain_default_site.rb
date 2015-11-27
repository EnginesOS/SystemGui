class DomainDefaultSite

  include ActiveModel::Model
  include ActiveModel::Validations
  extend Engines::Api

  attr_accessor :default_site

  validates :default_site, presence: true

  def self.load
    new(default_site: engines_default_site)
  end

  def update
    valid? && update_default_site
  end

  def self.engines_default_site
    @engines_default_domain ||= engines_api.get_default_site
  rescue
    "error"
  end

  def update_default_site
    result = self.class.engines_api.set_default_site(default_site_url: default_site)
    if !result.was_success
      @engines_api_error = [ @engines_api_error.to_s, "Unable to update default site.",  
                            (result.result_mesg.present? ? result.result_mesg : "No result message given by engines api."),
                                  "Called 'set_default_site' with default_site: #{default_site}" ].join(' ')
    end
    result.was_success
  end
  
  def new_record?
    false
  end

end