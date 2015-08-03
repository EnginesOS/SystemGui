class ApplicationServicesProperties < ActiveRecord::Base

  include Engines::Api

  belongs_to :application
  
   def build_application_services
      application_services = application.application_services.build(build_application_services_attributes)
      application_services.each do |application_service|
        application_service.build_show
      end
  end

  def properties_from_system
    @properties ||= application.services_properties
  end
  
  def build_application_services_attributes
    properties_from_system.map do |application_service|
      params_for_build_application_service application_service
    end
  end
  
  def params_for_build_application_service application_service
      {
        publisher_namespace: application_service[:publisher_namespace],
        type_path: application_service[:type_path],
        service_handle: application_service[:service_handle]
      }
  end

end



  # def fully_defined_variables_attributes_for(application_service)
# p     service_detail_for application_service   
# p :service_detail_above
# []
  # end
# 
  # def service_detail_for(application_service)
      # engines_api.templated_software_service_definition(
                          # parent_engine: application.container_name,
                          # publisher_namespace: application_service[:publisher_namespace],
                          # type_path: application_service[:type_path])
  # end


#   
  # :publisher_namespace => "EnginesSystem",
                     # :type_path => "filesystem/local/filesystem",
                     # :variables => {
                     # :name => "mahara",
               # :volume_src => " ",
              # :permissions => "rw",
              # :engine_path => "/home/fs/datadir",
            # :parent_engine => "mahara"
        # },
                  # :service_type => "filesystem/local/filesystem",
                    # :persistant => true,
                 # :parent_engine => "mahara",
                # :service_handle => "mahara",
                         # :fresh => true,
                # :container_type => "container",
        # :service_container_name => "volmanager"
    # }
 
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
 









