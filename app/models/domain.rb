class Domain < ActiveRecord::Base

  extend Engines::Api

  attr_accessor(
    :original_domain_name,
    :domain_name,
    :internal_only,
    :self_hosted,
    :new_record,
    :engines_api_error)

  domain_name_regex = /^([a-zA-Z0-9][-a-zA-Z0-9]*[a-zA-Z0-9]\.)+(?!local)([a-zA-Z0-9]{2,5})$|^local$/
  validates :domain_name, presence: true, format: { with: domain_name_regex, :multiline => true  }

  def self.load_all
    all_engines_domain_names_params.map do |domain_name_params|
      new domain_name_params
    end
  end

  def self.build_new
    self.new(new_record: true)
  end

  def self.build_edit_for domain_name
    self.new(new_record: false, domain_name: domain_name, original_domain_name: domain_name).load_domain_properties
  end

  def load_domain_properties
    self.assign_attributes(engines_domain_params)
    self
  end


  def destroy
    self.class.engines_api.remove_domain(domain_name: domain_name)
  end

  def new_record?
    self.new_record.to_s == 'true'
  end

  def create
    valid? && create_domain
  end

  def update
    valid? && update_domain
  end

  def create_domain
    result = self.class.engines_api.add_domain create_domain_params
    if !result.was_success
      @engines_api_error = 'Unable to create domain. ' + (result.result_mesg.present? ? result.result_mesg : "No result message given by engines api. Called 'add_domain(#{create_domain_params})'")
    end
    result.was_success
  end

  def update_domain
    result = self.class.engines_api.update_domain update_domain_params
    if !result.was_success
      @engines_api_error = 'Unable to update domain. ' + (result.result_mesg.present? ? result.result_mesg : "No result message given by engines api. #{update_domain_params}")
    end
    result.was_success
  end

  def create_domain_params
      {
        domain_name: domain_name,
        internal_only: internal_only == "1",
        self_hosted: self_hosted == "1"
      }
  end

  def update_domain_params
      {
        original_domain_name: original_domain_name,
        domain_name: domain_name,
        internal_only: internal_only == "1",
        self_hosted: self_hosted == "1"
      }
  end

  def self.domain_names_list
    @domain_names_list ||= all_engines_domain_names_details.keys.map(&:to_s).sort
  end

  def engines_domain_params
    @engines_domain_params ||= self.class.all_engines_domain_names_details[domain_name.to_s]
  end

  def self.all_engines_domain_names_details
    @all_engines_domain_names_details ||= engines_api.list_domains
  end

  def self.all_engines_domain_names_params
    engines_domains = all_engines_domain_names_details
    engines_domains[:domain_name] = engines_domains[:name]
    engines_domains.values.select { |d| d.present? }.map { |d| d.slice(:domain_name, :internal_only, :self_hosted) }
  end

end
