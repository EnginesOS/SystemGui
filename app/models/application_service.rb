class ApplicationService < ActiveRecord::Base

  include Engines::Api

  attr_accessor(
    :type_path,
    :publisher_namespace,
    :service_container_name,
    # :parent_application_name,
    :service_handle,
    :create_type,
    # :parent_engine,
    :wizard_create_type,
    :wizard_orphan_service,
    :wizard_active_service,
    :engines_api_error
    )

  belongs_to :application
  has_many :application_subservices, dependent: :destroy
  has_many :variables, as: :variable_consumer, dependent: :destroy
  accepts_nested_attributes_for :application_subservices
  accepts_nested_attributes_for :variables
  
  # def load
    # p :application_id
    # p application_id
    # load_variable_definitions && load_variable_values
    # self
  # end







  
  def build_for_show
    load_subservices
    load_variables
    self
  end
  
  def load_variable_definitions
    variable_definitions.each do |variable_definition|
      variables.build(variable_definition)
    end
  end
   
  def load_subservices
    # application.attached_services_hash.each do |subservice_params|
#       
    # end
  end
   
   
  def load_variables
    load_variable_definitions
    variables.each do |variable|
      
      p :variable_values____________________________________________________________
      p variable_values
      p :variable_values____________________________________________________________
      p variable_values.class
      p :variable_values____________________________________________________________
      
      
      if variable_values[variable.name.to_sym].present?
        variable.value = variable_values[variable.name.to_sym]
      end
    end
  end
  
  def variable_values
    p :attached_service_hash
    p attached_service_hash
    p :attached_service_hash_______________________________________________________________________
    attached_service_hash[:variables]
  end
  
  def create
    valid? && create_attached_service
  end
  
  def create_attached_service
    result = engines_api.attach_service(to_json)
    if !result.was_success
      @engines_api_error = (result.result_mesg.present? ? result.result_mesg : "Unable to create attached service. No result message given by engines api. Called 'attach_service' with params: #{to_json}")
    end
    result.was_success
  end
  
  def to_json
      {parent_engine: application.container_name,
      type_path: type_path,
      publisher_namespace: publisher_namespace,
      variables: varaibles_params}
   end 
   
   def varaibles_params
     {}.tap do |result|
       variables.each do |variable|
         result[variable.name.to_sym] = variable.value
       end
     end
   end
  

  # def application_name
    # parent_application_name || application.container_name
  # end
# 
# 
# 
# 
# 
  # def container_name
    # application_name
  # end
# 
  # def container
    # @container ||= engines_api.loadManagedEngine application_name
  # end
# 
  # def available_services_hash
    # engines_api.list_avail_services_for container
  # end
# 
# 
#   
  def attached_service_hash
    @attached_service_hash ||= application.attached_services_hash.
                                  find{ |service| service[:publisher_namespace] == publisher_namespace && service[:type_path] == type_path && service[:service_handle] == service_handle }
  end
# 
  def available_subservices
    application.available_services_hash[:subservices][type_path]
  end

######

  def service_detail
    
    p :pppppppppppppppppppppppppppppppppppppppppppublisher_namespace
    p publisher_namespace
    p :ttttttttttttttttttttttttttttttttttttttttttttype_path
    p type_path
    
    @service_detail ||= engines_api.software_service_definition(
                        publisher_namespace: publisher_namespace,
                        type_path: type_path)
  end

#####

  def title
    service_detail[:title]
  end
  
  def description
    service_detail[:description]
  end

  def persistant
    service_detail[:persistant]
  end

  def variable_definitions
    @variable_definitions ||= service_detail[:consumer_params].values
  end    


  # def registered_subservices_hash
    # @application.registered_services_hash
  # end
# 
  # def registered_subservices
    # []
    # # [].tap do |result|
      # # registered_services_hash.each do |registered_service|
        # # result << Engines::Applications::ServiceRegistration.new(self).build(registered_service)
      # # end
    # # end
  # end



  def attachable_active_attached_services
    engines_api.get_registered_against_service(type_path: type_path, publisher_namespace: publisher_namespace).map do |service|
      if service[:parent_engine] == service[:service_handle]
        service[:parent_engine]
      else
        "#{service[:parent_engine]} - #{service[:service_handle]}"
      end
    end
  end

  def attachable_orphaned_attached_services
    engines_api.get_orphaned_services(type_path: type_path, publisher_namespace: publisher_namespace).map do |service|
      if service[:parent_engine] == service[:service_handle]
        service[:parent_engine]
      else
        "#{service[:parent_engine]} - #{service[:service_handle]}"
      end
    end
  end


end











# after_create :build_new_variables

# def title
  # engines_service.title
# end
# 
# def description
  # engines_service.description
# end
# 
# def persistant
  # engines_service.persistant
# end
# 
# def build
  # engines_service.variable_definitions.each do |variable_definition|
    # variable = variables.build(variable_definition)
  # end
# end
# 
# def create
  # engines_service.create create_varaible_params
 # end 
#  
 # def create_varaible_params
   # {}.tap do |result|
     # variables.each do |variable|
       # result[variable.name] = variable.value
     # end
   # end
 # end
  

  # def self.attach_service params
    # engines_api.attach_service params
  # end
# 
  # def self.detach_service params
    # engines_api.detach_service params
  # end
# 
  # def self.attach_subservice params
    # engines_api.attach_subservice params
  # end
#   
  # def self.detach_subservice params
    # engines_api.detach_subservice params
  # end
  


# private

  # def engines_application
    # @enignes_application ||= Engines::Applications::Application.new application_name
  # end
# 
  # def engines_service
    # @engines_service ||= engines_application.new_service_for publisher_namespace, type_path
  # end




# end




  # accepts_nested_attributes_for :attached_subservices
# 
# 

# 
  
# 








