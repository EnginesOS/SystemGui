class Domain < ActiveRecord::Base

  extend Engines::Api

  attr_accessor(
    :original_domain_name,
    :domain_name,
    :internal_only,
    :self_hosted,
    :engines_api_error)

  domain_name_regex = /^([a-zA-Z0-9][-a-zA-Z0-9]*[a-zA-Z0-9]\.)+([a-zA-Z0-9]{2,5})$/
  validates :domain_name, presence: true, format: { with: domain_name_regex, :multiline => true  }

  def self.load_all
    all_engines_domain_names_params.map do |domain_name_params|
      new domain_name_params
    end
  end
  
  def self.load(domain_name)
    domain_params = engines_domain_params_for domain_name
    new(domain_params)
  end
#   
  # def load_settings
    # self.assign_attributes(
      # internal_only: domain_name_detail[:internal_only],
      # self_hosted: domain_name_detail[:self_hosted])
  # end
  

  def destroy
    self.class.engines_api.remove_domain(domain_name: domain_name)
  end

  # def key
    # domain_name.gsub('.', '%') if !new_record?
  # end
#  
  # def self.domain_name_to_key(domain_name)
    # domain_name.gsub('.', '%')
  # end
#  
  # def self.key_to_domain_name(key)
    # key.gsub('%', '.')
  # end
  
  def new_record? 
    !domain_name.present?
  end
  
  def create
    valid? && create_domain
  end

  def update
    valid? && update_domain
  end

  def create_domain
    self.class.engines_api.add_domain(
      domain_name: domain_name,
      internal_only: internal_only == "1",
      self_hosted: self_hosted == "1").was_success
  end

  def update_domain
    params = {
      original_domain_name: original_domain_name,
      domain_name: domain_name,
      internal_only: internal_only == "1",
      self_hosted: self_hosted == "1"
      }
    result = self.class.engines_api.update_domain params
    if !result.was_success
      @engines_api_error = (result.result_mesg.present? ? result.result_mesg : "Unable to update domain. No result message given by engines api. #{params}")
    end
    result.was_success
  end

  def self.domain_names_list
    all_engines_domain_names_details.keys.sort
  end
# 
  # def domain_name_detail
    # self.class.domain_names_hash.select{|name, detail| name == domain_name}
  # end
  
  def self.engines_domain_params_for(domain_name)
    all_engines_domain_names_details[domain_name]
  end

  def self.all_engines_domain_names_details
    engines_api.list_domains
  end
  
  def self.all_engines_domain_names_params
    engines_domains = all_engines_domain_names_details
    engines_domains[:domain_name] = engines_domains[:name]
    engines_domains.values.select { |d| d.present? }.map { |d| d.slice(:domain_name, :internal_only, :self_hosted) }
  end

  # def self.domain_names_hash
    # @domain_names_hash ||= engines_api_list_domains
#     
    # # .
    # # {"owen.demo"=>{:domain_name=>"owen.demo", :internal_only=>true, :self_hosted=>true}, "test.this"=>{"domain_name"=>"test.this", "internal_only"=>false, "self_hosted"=>false}}.
    # # select{|name, detail| name == } #.with_indifferent_access
  # end

end