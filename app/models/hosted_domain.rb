class HostedDomain < ActiveRecord::Base

  # validates_presence_of :hosted_domain

  # include ActiveModel::Model
  # include Engines::Api

  belongs_to :system_config



  def self.engines_api
    EnginesApiHandler.engines_api
  end

  def engines_api
    self.engines_api
  end



  def save_via_api
    # params[:domain_name]
    # params[:internal_only]
p 'domain_name and internal_only...............................................'
p domain_name
p internal_only

    engines_api.add_self_host_domain ({domain_name: domain_name, internal_only: internal_only})

  end

#   def update params
#     engines_api.update_self_hosted_domain ({hosted_domain: params[:hosted_domain], internal_only: params[:internal_only]})
#   end

#   def destroy
#     engines_api.remove_self_hosted_domain domain_name
#   end

  # def self.new_from_domain_name domain_name
  #   self.alll[domain_name]
  # end

#   def self.load_all
#     result = []
#     self_hosted_domains_hash.each do |name, params|
# p 'hosted domain params...................'
# p params
#       a = self.new(params)
# p a
#       result << a
#     end

# p result

#     return result
#   end

  # def self.list_all
  #   self.load_all.each do |hosted_domain|
  #     hosted_domain[:domain_name]
  #   end
  # end

  def self.self_hosted_domains_hash
    self.engines_api.list_self_hosted_domains
    {
      'jonesfamily.org' => {domain_name: 'jonesfamily.org', internal_only: true},
      'zonepartners.net' => {domain_name: 'zonepartners.net', internal_only: false}
    }
    # # return a Hash or EnginesOSapiResult if error
#     result = []
#     self_hosted_domains_hash.keys.each do |domain_name|
#       result << HostedDomain.new(domain_name: domain_name, internal_only: self_hosted_domains_hash[domain_name][:internal_only])
# p 'result.............................................'
# p result
#     end
#     return result
  end

  # def count_of_self_hosted_domains
  #   list_self_hosted_domains.keys.count
  # end
end