class Domain < ActiveRecord::Base

  extend Engines::Api

  attr_accessor(
    :original_domain_name,
    :domain_name,
    :internal_only,
    :self_hosted)

  domain_name_regex = /^([a-zA-Z0-9][-a-zA-Z0-9]*[a-zA-Z0-9]\.)+([a-zA-Z0-9]{2,5})$/
  validates :domain_name, presence: true, format: { with: domain_name_regex, :multiline => true  }

  def self.load_all
    domain_names_list.map{ |domain_name| new(domain_name: domain_name) }
  end
  
  def self.load domain_name
    new(domain_name: domain_name).tap do |domain|
      domain.assign_attributes(
        internal_only: domain_names_hash[:internal_only],
        self_hosted: domain_names_hash[:self_hosted])
    end
  end

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
    self.class.engines_api.update_domain(
      original_domain_name: original_domain_name,
      domain_name: domain_name,
      internal_only: internal_only == "1",
      self_hosted: self_hosted == "1").was_success
  end

  def self.domain_names_list
    domain_names_hash.keys.sort
  end

  def self.domain_names_hash
    @domain_names_hash ||= engines_api.list_domains.
    # {"owen.demo"=>{:domain_name=>"owen.demo", :internal_only=>true, :self_hosted=>true}, "test.this"=>{"domain_name"=>"test.this", "internal_only"=>false, "self_hosted"=>false}}.
    select{|name, detail| name.present?} #.with_indifferent_access
  end

end