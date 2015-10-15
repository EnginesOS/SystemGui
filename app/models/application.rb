class Application < ActiveRecord::Base

  include Engines::Application
  extend Engines::Api

  has_one :application_variables_properties, dependent: :destroy
  has_one :application_services_properties, dependent: :destroy
  has_many :application_service_connectors, dependent: :destroy
  has_one :application_display_properties, dependent: :destroy
  has_one :application_network_properties, dependent: :destroy
  has_one :application_resources_properties, dependent: :destroy
  has_many :eports, dependent: :destroy
  has_many :variables, as: :variable_consumer, dependent: :destroy
  has_many :application_services, dependent: :destroy

  has_one :install_from_blueprint, dependent: :destroy
  has_one :install_from_docker_hub, dependent: :destroy

  accepts_nested_attributes_for :variables
  accepts_nested_attributes_for :application_service_connectors
  accepts_nested_attributes_for :application_network_properties
  accepts_nested_attributes_for :application_display_properties
  accepts_nested_attributes_for :application_resources_properties
  accepts_nested_attributes_for :install_from_blueprint
  accepts_nested_attributes_for :eports

  name_regex = /^[A-Za-z0-9]*$/
  validates :container_name, {format: { with:name_regex, multiline: true, 
      message: "is invalid (please use characters a-z and 0-9)" },
    length: {minimum: 3, maximum: 24}}

  def show_on_desktop?
    active? || default_startup_state == 'running'
  end

# class methods
  
  def self.load_all
    application_container_names_list.map do |container_name|
      load_by_container_name(container_name)
    end
  end

  def self.load_by_container_name(container_name)
    application = where(container_name: container_name).first_or_create
    application.save
    if application.application_display_properties.blank?
      application.build_application_display_properties.set_defaults
    end
    application
  end
  
  def self.desktop_applications
    load_all.select { |application| application.show_on_desktop? }    
  end
  
  def self.application_container_names_list
    engines_api.list_apps.sort
  end

end
