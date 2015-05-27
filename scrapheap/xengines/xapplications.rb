# module Engines::Applications
# 
    # extend Engines::Api
# 
    # # def self.application_container_names
      # # result = engines_api.list_apps.sort
      # # if result.kind_of?(EnginesOSapiResult)
        # # []
      # # else
        # # result
      # # end
    # # end
#     
    # def self.all
      # application_container_names.map { |container_name| Engines::Applications::Application.new container_name }
    # end
# 
    # def self.desktop_applications
      # all.select { |application| application.show_on_desktop? }
    # end
# 
# end