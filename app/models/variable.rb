class Variable < ActiveRecord::Base

  attr_accessor(
    :name,
    :value,
    :label,
    :comment,
    :type,
    :regex_validator,
    :mandatory,
    :collection,
    :ask_at_build_time,
    :build_time_only,
    :immutable)

  belongs_to :software

#   def self.load_from_api engine_name
#     @software = Software.find_by engine_name: engine_name
#     @software.variables.destroy_all
#     environment_variables = EnginesSoftware.environment_variables(engine_name)

# # p :environment_variables
# # p environment_variables

# #     @software.variables.each do |v|

# # p '********is nil?*********'
# # p v.name.nil?

# #       v.delete if v.name.nil?
# #     end

# #     existing_variables = @software.variables.map{ |v| v.inspect }
# #     expected_variables = environment_variables.map{ |ev| ev[:name] }
# #     surplus_variables = existing_variables - expected_variables
# #     missing_variables = expected_variables - existing_variables

# # p :existing_variables
# # p existing_variables

# # p :expected_variables
# # p expected_variables

# #     surplus_variables.each do |variable_name|

# # p '-----------delete surplus variable---------------------'

# #       @software.variables.find_by(name: variable_name).destroy
# #     end

# #     missing_variables.each do |variable_name|

# # p '-----------build missing variable---------------------'

# #       @software.variables.create(name: variable_name)
# #     end

#     environment_variables.each do |environment_variable|
#       variable = @software.variables.build
#       variable.name = environment_variable[:name]
#       variable.value = environment_variable[:value]
#       variable.label = environment_variable[:label]
#       variable.comment = environment_variable[:comment]
#       variable.type = environment_variable[:type]
#       variable.regex_validator = environment_variable[:regex_validator]
#       variable.mandatory = environment_variable[:mandatory]
#       variable.collection = environment_variable[:collection]
#       variable.ask_at_build_time = environment_variable[:ask_at_build_time]
#       variable.build_time_only = environment_variable[:build_time_only]
#       variable.immutable = environment_variable[:immutable]
#     end
#     @software
#   end

  def self.save_to_api params
    EnginesSoftware.update_variables(params).was_success
  end

  # def self.load_from_params params

  #   params.values.each do |environment_variable|
  #     variable = @software.variables.build
  #     variable.name = environment_variable[:name]
  #     variable.value = environment_variable[:value]
  #     variable.label = environment_variable[:label]
  #     variable.comment = environment_variable[:comment]
  #     variable.type = environment_variable[:type]
  #     variable.regex_validator = environment_variable[:regex_validator]
  #     variable.mandatory = environment_variable[:mandatory]
  #     variable.collection = environment_variable[:collection]
  #     variable.ask_at_build_time = environment_variable[:ask_at_build_time]
  #     variable.build_time_only = environment_variable[:build_time_only]
  #     variable.immutable = environment_variable[:immutable]
  #   end

  # end

# private

#   def self.params_for_api_update params
#     params.values 
#   end

# EnginesSoftware.environment_variables(engine_name)



#   def self.load_engines_software_environment_variables
# p :EnginesSoftware_environment_variables
# p EnginesSoftware.environment_variables(engine_name)

#     self.software_environment_variables_attributes = EnginesSoftware.environment_variables(engine_name)
#     self
#   end

#   # environment variables update is handled by the same method as update runtime properties
#   def update_software_variables params
#     EnginesSoftware.update_runtime(params).was_success
#   end

end




#   def load_from_api
#     self.host_name = EnginesSoftware.host_name software.engine_name
#     self.domain_name = EnginesSoftware.domain_name software.engine_name
#     self.http_protocol = EnginesSoftware.http_protocol software.engine_name
#     self
#   end

#   def save_to_api params
#     load_from_params params
#     return false if !save

#     result = EnginesSoftware.update_host_name(params_for_api_update)
#     if result.was_success == false
#       errors.add(:base, result.result_mesg)
#       return false
#     end

#     result = EnginesSoftware.update_domain_name(params_for_api_update)
#     if result.was_success == false
#       errors.add(:base, result.result_mesg)
#       return false
#     else
#       return true
#     end

#   end

#   def self.best_default_domain
#     Setting.first_or_create.default_domain || EnginesDomain.engines_domains.first
#   end

#   def self.best_http_protocol protocol
#     ['HTTPS only', 'HTTP only', 'HTTPS and HTTP'].include?(protocol) ? protocol : 'HTTPS and HTTP'
#   end

# private

#   def load_from_params params
#     self.host_name = params[:host_name]
#     self.domain_name = params[:domain_name]
#     self.http_protocol = params[:http_protocol]
#     self
#   end

#   def params_for_api_update
#     {
#       engine_name: software.engine_name,
#       host_name: host_name,
#       domain_name: domain_name,
#       http_protocol: http_protocol
#     }
#   end

#   def fqdn_is_unique_on_update?
#     return true if fqdn_unchanged?
#     fqdn_is_unique?
#   end

#   def fqdn_is_unique?
#     if EnginesInstaller.fqdn_is_unique? (host_name + '.' + domain_name)
#       true
#     else
#       errors.add(:base, 'The combination of host name plus domain name must be unique.')
#     end
#   end

#   def fqdn_unchanged?
#     EnginesSoftware.fqdn(software.engine_name) == (host_name.to_s + '.' + domain_name.to_s)
#   end
  
# end
