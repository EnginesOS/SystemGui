class Software < ActiveRecord::Base

  has_many :variables, dependent: :destroy
  has_one :display, dependent: :destroy
  has_one :network, dependent: :destroy
  has_one :resource, dependent: :destroy
  has_one :install, dependent: :destroy

  accepts_nested_attributes_for :variables
  accepts_nested_attributes_for :display
  accepts_nested_attributes_for :network
  accepts_nested_attributes_for :resource
  accepts_nested_attributes_for :install


  def load_display_property_defaults
    engines_software_details = EnginesSoftware.blueprint_software_details(engine_name)

p :engines_software_detailsqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
p engines_software_details


    self.display_name = engines_software_details['name']
    self.display_description = engines_software_details['description']
    self.icon = EnginesUtilities.icon_from_url(engines_software_details['icon_url'])
    self.terms_and_conditions_accepted = "1"

# next line needs to go once software model broken-out
    self.memory = EnginesSoftware.memory engine_name


    self
  end




  # def load_engines_software_display_parameters
  #   # self.form_type = :edit_display_properties
  # end

  # def load_engines_software_network_parameters
  #   self.form_type = :edit_network_properties
  #   self.host_name = EnginesSoftware.host_name engine_name
  #   self.domain_name = EnginesSoftware.domain_name engine_name
  #   self.http_protocol = EnginesSoftware.http_protocol engine_name
  #   self
  # end





#   def update_display_properties params

# p :params
# p params

#     update params
#   end

  # def update_network_properties params
  #   EnginesSoftware.update_hostname_properties(params).was_success &&
  #   EnginesSoftware.update_network_properties(params).was_success
  # end





  def self.user_visible_applications
    all.select { |software| EnginesSoftware.state_as_set_by_user(software.engine_name) == 'running' }
  end

private




  # def update_display_properties_params params
  #   {
  #     display_name: params[:display_name],
  #     display_description: params[:display_description],
  #     icon: params[:icon]
  #   }
  # end

  # def update_hostname_properties_params params
  #   {
  #     engine_name: engine_name,
  #     host_name: params[:host_name],
  #     domain_name: params[:domain_name]
  #   }
  # end

  # def update_network_properties_params params
  #   {
  #     engine_name: engine_name,
  #     http_protocol: params[:http_protocol]
  #   }
  # end

  # def update_runtime_params params
  #   {
  #     engine_name: engine_name,
  #     memory: params[:memory],
  #     environment_variables: params[:environment_variables_params]
  #   }
  # end

end