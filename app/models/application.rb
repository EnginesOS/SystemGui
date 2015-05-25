class Application < ActiveRecord::Base

  include Engines::Application
  extend Engines::Api

  # attr_accessor :remove_all_application_data
  # after_create :create_display_properties

  has_one :variables_properties, dependent: :destroy
  # has_one :services_properties, dependent: :destroy
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


  def load_application_services
    existing_attached_services.each do |attached_service|

p :attached_service
p attached_service      
      
      
      application_services.build(attached_service.delete(:subservices)) #.build_for_show
    end
    self
  end

  def existing_attached_services
    @existing_attached_services ||= application_attached_services
  end  
  
  def application_attached_services
    parent_services = []
    child_services = []
    attached_services_hash.each do |attached_service_definition|
     p :attached_service_definition 
     p attached_service_definition = attached_service_definition.slice(:publisher_namespace, :type_path, :service_handle, :service_container_name, :parent_service)
      if attached_service_definition[:parent_service].nil?
        parent_services << attached_service_definition.merge(subservices: [])
      else
        child_services << attached_service_definition
      end
    end
    
    p :parent_services
    p parent_services
    p :child_services
    p child_services
    
    
    child_services.each do |child_service|

    p :child_service1
    p child_service      


      child_service_params = {
        publisher_namespace: child_service[:publisher_namespace],
        type_path: child_service[:type_path],
        service_handle: child_service[:service_handle]
      }
        

      parent_services = parent_services.map do |parent_service|
        
    p :parent_service
    p parent_service
    p :child_service
    p child_service      
        
        
        if parent_service[:publisher_namespace] = child_service[:parent_service][:publisher_namespace] &&
              parent_service[:type_path] = child_service[:parent_service][:type_path] &&
              parent_service[:service_handle] = child_service[:parent_service][:service_handle]
           parent_service[:subservices] << child_service_params
        end
        parent_service   
      end
    end
    
    p :parent_services
    p parent_services
    
    
    
    parent_services
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
# 
  def display_properties
    super || create_display_properties.set_defaults
  end
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


