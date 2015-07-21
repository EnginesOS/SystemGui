class ApplicationServicesProperties < ActiveRecord::Base

  # include Engines::Api

  # after_initialize :load
  # before_save :write_data

  belongs_to :application
  
  
  
   def build_for_show
    # application.existing_attached_services.each do |attached_service|
# 
# attached_service = attached_service.except(:application_subservices)
# 
# p :__________________________________________________________________________________________________________________attached_service
# p attached_service      
# 
#       
      application.application_services.build(application.services_properties_definition) #.build_for_show
    # end
    # self


  end


 
  # has_many :application_services, through: :application
  # has_many :variables, through: :application
  # accepts_nested_attributes_for :application_services

  # def application_name
    # application.container_name
  # end
# 
  # def available_services
    # application.available_services
  # end
# 
  # def container_name
    # application_name
  # end
# 
  # def container
    # @container ||= engines_api.loadManagedEngine application_name
  # end
# 
# 
  # def attached_services_hash
    # engines_api.list_attached_services_for('ManagedEngine', container_name)
  # end







  # def attached_services
    # attached_services_hash
  # end
  
  
  
  # def variables_definitions
    # application.blueprint_software_details['variables']
  # end


  # def update_variables
    # application.update_variables(write_params)
  # end
  
  # def write_params
    # {
      # engine_name: application_name,
      # environment_variables: variables_write_params
    # }
  # end
# 
  # def variables_write_params
    # params = {}
    # variables.map do |variable|
      # params[variable.name] = variable.value
    # end
    # params
  # end



  # def write_update_data
    # new_record? || update_variables
  # end
 

 
end







