class HostedDomain < ActiveRecord::Base

  # validates_presence_of :hosted_domain

  # include ActiveModel::Model
  # include Engines::Api

  belongs_to :system_config



  def self.engines_api
    EnginesApiHandler.engines_api
  end

  def engines_api
    EnginesApiHandler.engines_api
  end



  def save_via_api
    # params[:domain_name]
    # params[:internal_only]
p 'domain_name and internal_only...............................................'
p domain_name
p internal_only

# p engines_api

    engines_api.add_self_hosted_domain ({domain_name: domain_name, internal_only: internal_only})

  end

  def update_via_api params
p :sssssssssssssssssssssssssssssssssss
p params
    engines_api.update_self_hosted_domain params[:old_domain_name], {domain_name: params[:domain_name], internal_only: params[:internal_only]}
  end

  def destroy_via_api


p 'domain_name///////////////////////////////////'
p domain_name

    engines_api.remove_self_hosted_domain domain_name
  end

  def self.refresh_db_and_load_all
    self.delete_all
    self.load_all_via_api
  end

  def self.load_all_via_api
    result = []
    self.self_hosted_domains_hash.each do |name, params|
      hosted_domain = self.new(params)
      hosted_domain.save
      result << hosted_domain
    end
    return result
  end

  def self.self_hosted_domains_hash
    self.engines_api.list_self_hosted_domains
  end

end