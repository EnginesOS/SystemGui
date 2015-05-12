class Application < ActiveRecord::Base

  include Engines::Application
  extend Engines::Api

  # attr_accessor :remove_all_application_data
  # after_create :create_display_properties

  has_one :variables_properties, dependent: :destroy
  has_one :services_properties, dependent: :destroy
  has_one :backup_properties, dependent: :destroy
  has_one :display_properties, dependent: :destroy
  has_one :network_properties, dependent: :destroy
  has_one :resources_properties, dependent: :destroy
  has_many :eports, dependent: :destroy
  has_many :variables, as: :variable_consumer, dependent: :destroy
  has_many :application_services, dependent: :destroy

  belongs_to :application_installation, dependent: :destroy
  belongs_to :docker_hub_installation, dependent: :destroy

  accepts_nested_attributes_for :variables
  accepts_nested_attributes_for :application_services
  accepts_nested_attributes_for :network_properties
  accepts_nested_attributes_for :resources_properties


#class methods
  
  def self.load_all
    application_container_names_list.map do |container_name|
      where(container_name: container_name).first_or_create
    end
  end
  
  def self.desktop_applications
    load_all.select { |application| application.show_on_desktop? }    
  end
  
  def self.application_container_names_list
    engines_api.list_apps.sort
  end

  def display_properties
    super || create_display_properties.set_defaults
  end

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

