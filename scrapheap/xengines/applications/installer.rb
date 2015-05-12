module Engines::Applications

  class Installer

    include Engines::Api
  
    # attr_accessor :type_path, :publisher_namespace, :persistant, :service_handle, :variables
# 
# 
# :repository_url, 
    # :default_image_url,
    # :langauge_name,
    # :swframework_name,
    # :license_name,
    # :license_label,
    # :license_sourceurl,
    # :license_terms_and_conditions,
    # :blueprint

  
    def initialize(gallery_url, software_id)
      @gallery_url = gallery
      @software_id = software_id
    end


  
    # def build(params)
      # @type_path = params[:type_path]
      # @publisher_namespace = params[:publisher_namespace]
      # @service_handle = params[:service_handle]
      # self
    # end    
#   
    # def persistant
      # service_detail[:persistant]
    # end
#   
    # def variable_definitions
      # @variable_definitions ||= service_detail[:consumer_params].values
    # end    
#   
    # def title
      # service_detail[:title]
    # end
#     
    # def description
      # service_detail[:description]
    # end
#   
    # def service_detail
      # @service_detail ||= engines_api.software_service_definition(
                          # publisher_namespace: @publisher_namespace,
                          # type_path: @type_path)
    # end
#   
    # def available_subservices
      # @application.available_services_hash[:subservices][@type_path]
    # end
#   
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
#   
   # def create(variable_params)
     # engines_api.attach_service(
        # parent_engine: @application.name,
        # publisher_namespace: publisher_namespace,
        # type_path: type_path,
        # variables: variable_params
      # )
    # end
#   
  end
end

