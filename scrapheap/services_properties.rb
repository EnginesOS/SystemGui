# module Engines::ServicesProperties
#   
  # def engines_api
    # Engines::Api.instance.engines_api
  # end
# 
# #application_loader
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
  # def attached_services_hash
    # engines_api.list_attached_services_for('ManagedEngine', container_name)
  # end
# 
  # def available_services
    # available_services_hash[:services]
  # end
# 
  # # def attached_services
    # # attached_services_hash
  # # end
#   
#   
#   
  # # def variables_definitions
    # # application.blueprint_software_details['variables']
  # # end
# 
# 
  # # def update_variables
    # # application.update_variables(write_params)
  # # end
#   
  # # def write_params
    # # {
      # # engine_name: application_name,
      # # environment_variables: variables_write_params
    # # }
  # # end
# # 
  # # def variables_write_params
    # # params = {}
    # # variables.map do |variable|
      # # params[variable.name] = variable.value
    # # end
    # # params
  # # end
# 
# end