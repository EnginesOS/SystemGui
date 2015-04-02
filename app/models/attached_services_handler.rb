class AttachedServicesHandler < ActiveRecord::Base

  belongs_to :software
  has_many :attached_services

  accepts_nested_attributes_for :attached_services

  def load_attached_services
    attached_services.build(attached_services_params_from_api)
  end
  
  def load_attached_services_details
    attached_services.each do |attached_service|
      service_detail = EnginesAttachedService.service_detail_for(attached_service.type_path, attached_service.publisher_namespace)
      if service_detail.kind_of?(EnginesOSapiResult)
        service_detail = {title: "Error", description: "Could not load service detail."}
      end
      attached_service.title = service_detail[:title]
      attached_service.description = service_detail[:description]
    end
  end

  def available_services_hash
    @available_services_hash ||= EnginesAttachedService.available_services(software.engine_name)
  end

  def available_services
    available_services_hash[:services]
  end

  def available_subservices(type_path)
    available_services_hash[:subservices][type_path]
  end
  
  def attached_services_from_api
    @attached_services_from_api ||= EnginesSoftware.attached_services(software.engine_name)
  end

  def service_detail(type_path, publisher_namespace)
    EnginesAttachedService.service_detail_for(type_path, publisher_namespace)
  end

  def docker_hub_install_available_services
    EnginesAttachedService.docker_hub_install_available_services[:services]
  end


  # def service_detail(type_path, publisher_namespace)
    # available_services.find do |service|
      # service[:type_path] == type_path &&
      # service[:publisher_namespace] == publisher_namespace
    # end
  # end



  # def volumes
    # @volumes ||= EnginesSoftware.volumes software.engine_name
  # end





private

  def attached_services_params_from_api
    result = []
    attached_services_from_api.each do |attached_service|
      service_detail = EnginesAttachedService.service_detail_for(attached_service[:type_path], attached_service[:publisher_namespace])
      if service_detail.kind_of?(EnginesOSapiResult)
        service_detail = {title: "Error", description: "Could not load service detail."}
      end
      result << {
        description: service_detail[:description],
        title: service_detail[:title],
        service_handle: attached_service[:service_handle],
        type_path: attached_service[:type_path],
        publisher_namespace: attached_service[:publisher_namespace],
        persistant: attached_service[:persistant],
        attached_subservices_attributes: [{title: "hi"}]
      }
    end
    result
  end






#   def params_for_api_update
#     {
#       engine_name: engine_name,
#       services: {hash_key: "dunno"}
#     }

#     #     attached_services.map do |attached_service|
#     #       {
#     #         service_type: attached_service.service_type,
#     #         service_provider: 'something_or_other',

#     #       }
#     #     end

#     #   environment_variables:
#     #     variables.map do |variable|
#     #       {
#     #         name: variable.name,
#     #         value: variable.value
#     #       }
#     #     end


#     # }

#   end

end