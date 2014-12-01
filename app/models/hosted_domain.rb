class HostedDomain < ActiveRecord::Base
  has_no_table
  column :hosted_domain, :string
  column :internal_only, :boolean
  column :system_config_id, :integer
  validates_presence_of :hosted_domain

  # include ActiveModel::Model
  # include Engines::Api

  belongs_to :system_config

  def initialize params
    @hosted_domain = params[:domain_name]
    @internal_only = params[:internal_only]
  end

  def self.engines_api
    EnginesApiHandler.engines_api
  end

  def engines_api
    self.engines_api
  end

  def save
    # params[:domain_name]
    # params[:internal_only]
p 'hosted_domain and internal_only...............................................'
p hosted_domain
p internal_only

    engines_api.add_self_host_domain ({hosted_domain: hosted_domain, internal_only: internal_only})
  end

  def update params
    engines_api.update_self_hosted_domain ({hosted_domain: params[:hosted_domain], internal_only: params[:internal_only]})
  end

  def destroy
    engines_api.remove_self_hosted_domain domain_name
  end

  def self.find domain_name
    self.alll[domain_name]
  end

  def HostedDomain.alll
    self_hosted_domains_hash = self.engines_api.list_self_hosted_domains
    self_hosted_domains_hash = {
      'jonesfamily.org' => {domain_name: 'jonesfamily.org', internal_only: true},
      'zonepartners.net' => {domain_name: 'zonepartners.net', internal_only: false}
    }
    # # return a Hash or EnginesOSapiResult if error
    result = []
    self_hosted_domains_hash.keys.each do |domain_name|
      result << HostedDomain.new(domain_name: domain_name, internal_only: self_hosted_domains_hash[domain_name][:internal_only])
p 'result.............................................'
p result
    end
    return result
  end

  # def count_of_self_hosted_domains
  #   list_self_hosted_domains.keys.count
  # end
end