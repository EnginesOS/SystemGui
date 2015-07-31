class Application < ActiveRecord::Base

  include Engines::Application
  extend Engines::Api

  # attr_accessor :remove_all_application_data
  # after_create :application_setup_display_properties

  has_one :application_variables_properties, dependent: :destroy
  has_one :application_services_properties, dependent: :destroy
  # has_one :application_backup_properties, dependent: :destroy
  has_one :application_display_properties, dependent: :destroy
  has_one :application_network_properties, dependent: :destroy
  has_one :application_resources_properties, dependent: :destroy
  has_many :eports, dependent: :destroy
  has_many :variables, as: :variable_consumer, dependent: :destroy
  has_many :application_services, dependent: :destroy

  belongs_to :application_installation, dependent: :destroy
  belongs_to :docker_hub_installation, dependent: :destroy

  # accepts_nested_attributes_for :application_variables_properties
  accepts_nested_attributes_for :variables
  accepts_nested_attributes_for :application_network_properties
  accepts_nested_attributes_for :application_display_properties
  accepts_nested_attributes_for :application_resources_properties
  accepts_nested_attributes_for :application_services
  accepts_nested_attributes_for :eports

  name_regex = /^[A-Za-z0-9]*$/
  validates :container_name, {format: { with:name_regex, multiline: true, 
      message: "is invalid (please use characters a-z and 0-9)" },
    length: {minimum: 3, maximum: 24}}

  def show_on_desktop?
    active? || default_startup_state == 'running'
  end

#class methods
  
  def self.load_all
    application_container_names_list.map do |container_name|
      load_by_container_name(container_name)
    end
  end

  def self.load_by_container_name(container_name)
    application = where(container_name: container_name).first_or_create
    application.save
    if application.application_display_properties.blank?
      application.build_application_display_properties.set_defaults.save
    end
    application
  end
  
  def self.desktop_applications
    load_all.select { |application| application.show_on_desktop? }    
  end
  
  def self.application_container_names_list
    engines_api.list_apps.sort
  end




  # def variables_properties
    # super || create_variables_properties
  # end
# 
  # def services_properties
    # super || create_services_properties
  # end
# 
  # def backup_properties
    # super || create_backup_properties
  # end
# # 
  # def loaded_display_properties
    # display_properties || 
  # end
# 
  # def network_properties
    # super || create_network_properties
  # end
# 
  # def resources_properties
    # super || create_resources_properties
  # end

end



# setup_params:
# consumer_params:
# configurators:
  # foo_props:
      # name: :foo_props
      # label: "Foo Properties"
      # description: "Some info to help the user."
      # params:
        # fizz_name:
              # name: :fizz_name
              # label: "Fizzer account name"
              # field_type: :text_field
              # name: fizz_key
              # label: "Fizzer account key"
              # field_type: :number_field
              # name: :foo_bar_token
              # label: "Token"
              # field_type: :text_field


