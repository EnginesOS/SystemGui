class ApplicationSubservice < ActiveRecord::Base

  include Engines::Api

  attr_accessor(
    :type_path,
    :publisher_namespace,
    :application_name,
    :parent_service_handle,
    :parent_publisher_namespace,
    :parent_type_path,
    :parent_title,
    :engines_api_error
    )
    # ,
    # :create_type,
    # :parent_engine,
    # :wizard_create_type,
    # :wizard_orphan_service,
    # :wizard_active_service
    # )

  has_many :variables, as: :variable_consumer, dependent: :destroy
  accepts_nested_attributes_for :variables

  belongs_to :application_service

  def load
    load_variables
  end

  def load_variables
    variable_definitions.each do |variable_definition|
      variables.build(variable_definition)
    end
  end

  def create
    valid? && create_attached_subservice
  end

  def create_attached_subservice
    @engines_api_error = ""
    result = engines_api.attach_subservice(to_json)
    if !result.was_success
      @engines_api_error = (result.result_mesg.present? ? result.result_mesg : "Unable to create attached subservice. No result message given by engines api. Called 'attach_subservice' with params: #{to_json}")
    end
    result.was_success
  end

  def to_json
    {parent_engine: application_name,
    type_path: type_path,
    parent_service: {
      service_handle: parent_service_handle,
      publisher_namespace: parent_publisher_namespace,
      type_path: parent_type_path
      },
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

  # def container_name
    # application_name
  # end

  # def container
    # @container ||= engines_api.loadManagedEngine application_name
  # end
# 
  # def available_services_hash
    # engines_api.list_avail_services_for container
  # end
# 
  # def attached_services_hash
    # @attached_services_hash ||= engines_api.list_attached_services_for('ManagedEngine', container_name)
  # end
#   
  # def attached_service_hash
    # @attached_service_hash ||= attached_services_hash.select{ |service| service[:publisher_namespace] == publisher_namespace && service[:type_path] == type_path }
  # end
# 
  # def available_subservices
    # available_services_hash[:subservices][type_path]
  # end

######

  def service_detail
    @service_detail ||= engines_api.templated_software_service_definition(
                        parent_engine: application_name,
                        parent_service: {
                          publisher_namespace: parent_publisher_namespace,
                          type_path: parent_type_path,
                          service_handle: parent_service_handle
                          },
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

# 
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



  # def attachable_active_attached_services
    # engines_api.get_registered_against_service(type_path: type_path, publisher_namespace: publisher_namespace).map do |service|
      # if service[:parent_engine] == service[:service_handle]
        # service[:parent_engine]
      # else
        # "#{service[:parent_engine]} - #{service[:service_handle]}"
      # end
    # end
  # end
# 
  # def attachable_orphaned_attached_services
    # engines_api.get_orphaned_services(type_path: type_path, publisher_namespace: publisher_namespace).map do |service|
      # if service[:parent_engine] == service[:service_handle]
        # service[:parent_engine]
      # else
        # "#{service[:parent_engine]} - #{service[:service_handle]}"
      # end
    # end
  # end


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








