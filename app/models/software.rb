class Software < ActiveRecord::Base

  attr_accessor(
    :name,
    :description,
    :requiredmemory,
    :image_url,
    :langauge_name,
    :swframework_name,
    :license_name,
    :license_sourceurl,
    :host_name,
    :domain_name,
    :http_protocol,
    :memory,
    :gallery_url,
    :blueprint_id,
    :terms_and_conditions_accepted,
    :delete_icon)

  has_attached_file :icon, :dependent => :destroy
  has_many :software_environment_variables
  has_many :software_environment_variable_values, through: :software_environment_variables

  accepts_nested_attributes_for :software_environment_variables
  accepts_nested_attributes_for :software_environment_variable_values

  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
  before_validation { icon.clear if delete_icon == '1' }

  def load_display_property_defaults
    engines_software = EnginesSoftware.software(engine_name)
    self.display_name = engines_software['name']
    self.display_description = engines_software['description']

p :image_url
p display_name
p engines_software['icon_url']
p :b
p engines_software

    self.icon = icon_from_url(engines_software['icon_url'])
    save

  end

  # def load_properties_from_engine
  #   requiredmemory = EnginesSoftware.software(engine_name)['requiredmemory']
  #   image_url = EnginesSoftware.software(engine_name)['icon_url']
  #   langauge_name = EnginesSoftware.software(engine_name)['langauge_name']
  #   swframework_name = EnginesSoftware.software(engine_name)['swframework_name']
  #   license_name = EnginesSoftware.software(engine_name)['license_name']
  #   license_sourceurl = EnginesSoftware.software(engine_name)['license_sourceurl']
  #   host_name = EnginesSoftware.host_name(engine_name)
  #   domain_name = EnginesSoftware.domain_name(engine_name)
  #   http_protocol = EnginesSoftware.http_protocol(engine_name)
  #   memory = EnginesSoftware.memory(engine_name)
  # end

#     app.software['environment_variables'].each do |env_variable|
#       # env_variable = nest_env_variable_value env_variable
#       # environment_variables.build(env_variable)


# # def nest_env_variable_value env_variable

#   env_variable_value = {"value" => env_variable["value"]}
#   env_variable.delete "value"
#   app_install_env_variable = self.software_environment_variables.new(env_variable)

#   if env_variable["allow_multiple"] == true
#     (env_variable_value = [env_variable_value]) if env_variable_value.instance_of? String 
#     env_variable_value["value"].each do |env_variable_value_element|
#       app_install_env_variable.software_environment_variable_values.new({"value" => env_variable_value_element})
#     end
#   else
#     app_install_env_variable_value = app_install_env_variable.software_environment_variable_values.new(env_variable_value)
#   end

# # end

#     end
  # end






  # after_create :set_display_properties_defaults

  # def self.all
  #   EnginesSoftware.all_engine_namesmap { |engine_name| self.find_or_create_by engine_name: engine_name }
  # end





#   def self.new_from_gallery params
#     app_install = self.new(params)

#     blueprint_software = app_install.software_definition_from_blueprint_in_repository
#     gallery_software = app_install.software_definition_from_gallery

#     app_install.engine_name ||= self.unique_engine_name_for(gallery_software['short_name'].gsub(/[^0-9A-Za-z]/, '').downcase)
#     app_install.host_name ||= self.unique_host_name_for(app_install.engine_name)
#     app_install.domain_name ||= SystemConfig.settings.default_domain
#     app_install.display_name ||= gallery_software['short_name']
#     app_install.http_protocol ||= (blueprint_software['http_protocol'] || 'HTTPS and HTTP')
#     app_install.display_description ||= gallery_software['description']
#     app_install.license_name ||= blueprint_software['license_name']
#     app_install.license_sourceurl ||= blueprint_software['license_sourceurl']
#     app_install.terms_and_conditions_accepted ||= false
    
#     if app_install.software_environment_variables.blank? 
#       blueprint_software['environment_variables'].each do |ev|
#         permitted_keys = [
#           :name, :value, :label, :comment, 
#           :build_time_only, :mandatory, 
#           :ask_at_build_time].map(&:to_s)
#         ev.select! {|k,v| permitted_keys.include? k}
# p :ev
# p ev        
# evv = {"value" => ev["value"]}
# ev.delete "value"
# p ev
# p evv

# app_install_env_variable = app_install.software_environment_variables.new(ev)

# if ev["allow_multiple"] == true
#   (evv = [evv]) if evv.instance_of? String 
#   evv["value"].each do |evvi|
#     app_install_env_variable.software_environment_variable_values.new({"value" => evvi})
#   end
# else
#   app_install_env_variable_value = app_install_env_variable.software_environment_variable_values.new(evv)
# end




# # values = ev['value']




# # p app_install
# # app_install.software_environment_variables.each do |aiev|
# #  aiev.software_environment_variable_values.each do |aievv|
# #    p aievv.value
# #  end
# # end 

# # p app_install.software_environment_variables.software_environment_variable_values

#       end
#     end

#     return app_install
#   end


#   def attach_icon_using_icon_url_from_gallery
#     self.icon = icon_from_url(software_definition_from_gallery['image_url'])
#   end

#   def app
#     @app_handler ||= EnginesSoftware.new(engine_name)
#   end

#   def update_display_properties params
#     update(update_display_properties_params params)
#   end

#   def update_network_properties params
#     engines_api.set_engine_hostname_properties(update_hostname_properties_params(params)).was_success &&
#     engines_api.set_engine_network_properties(update_network_properties_params(params)).was_success
#   end

#   def update_runtime_properties params
#     engines_api.set_engine_runtime_properties(update_runtime_properties_params params).was_success
#   end



#   def set_display_properties_defaults
#     if self.display_name.nil? && app.software.present?
#       self.display_name = app.software['name']
#       self.display_description = app.software['description']
#       if app.software['icon_url'].present?
#           self.icon = icon_from_url app.software['icon_url']
#       end
#       save
#     end
#   end




# # def clean_env_varialbe_params ev
# #   permitted_keys = [
# #     :name, :value, :label, :comment, 
# #     :build_time_only, :mandatory, 
# #     :ask_at_build_time].map(&:to_s)
# #   ev.select! {|k,v| permitted_keys.include? k}
# # end



#   def blueprint_handler
#     @blueprint_handler ||= EnginesSoftwareInstaller.new(gallery_url: gallery_url, blueprint_id: blueprint_id)
#   end

#   def software_definition_from_gallery
#     blueprint_handler.software_definition_from_gallery
#   end

#   def software_definition_from_blueprint_in_repository
#     blueprint_handler.blueprint_from_repository["software"]
#   end

#   def repository_url_from_gallery
#     blueprint_handler.repository.html_safe
#   end



#   # def find_or_create_by_engine_name engine_name

#   # end

# private

#   def update_display_properties_params params
#     {
#       display_name: params[:display_name],
#       display_description: params[:display_description],
#       icon: params[:icon]
#     }
#   end

#   def update_hostname_properties_params params
#     {
#       engine_name: engine_name,
#       host_name: params[:host_name],
#       domain_name: params[:domain_name],
#     }
#   end

#   def update_network_properties_params params
#     {
#       engine_name: engine_name,
#       http_protocol: params[:http_protocol]
#     }
#   end

#   def update_runtime_properties_params params
#     {
#       engine_name: engine_name,
#       memory: params[:memory],
#       environment_variables: params[:environment_variables_params]
#     }
#   end

#   def app_build_params
#     {
#       engine_name: engine_name,
#       host_name: host_name,
#       domain_name: domain_name,
#       http_protocol: http_protocol,      
#       gallery_url: gallery_url,
#       blueprint_id: blueprint_id,
#       memory: memory,
#       environment_variables: environment_variables_params
#     }
#   end

#   def environment_variables_params
#     hash = {}
#     environment_variables.each do |ev|
#       hash[ev.name] = ev.software_environment_variable_values.all.map(&:value)
#     end
#     return hash
#   end

  def icon_from_url url
  if url.present?
      begin
        begin
          @icon = URI.parse(url)
        rescue Exception=>e
          nil
        end
      rescue
        nil
      end
    end
  end

end