class AttachedServicesHandler < ActiveRecord::Base

  belongs_to :software
  has_many :attached_services

  accepts_nested_attributes_for :attached_services

  def load_attached_services
    # attached_services.delete_all
    attached_services.build(attached_services_params_from_api)
  end

  def available_services
    EnginesSoftware.available_services(software.engine_name) #[:services]
  end

private

  def attached_services_params_from_api

    result = []
    EnginesSoftware.attached_services(software.engine_name).each do |attached_service|

p :attached_service
p attached_service

      service_detail = EnginesAttachedService.service_detail_for(
        publisher_namespace: attached_service[:publisher_namespace],
        type_path: attached_service[:type_path])
      if service_detail.kind_of?(EnginesOSapiResult)
        service_detail = {title: "Title error", description: "Could not load service detail."}
      end

p :service_detail
p service_detail
            
      result << {
        description: service_detail[:description],
        title: service_detail[:title],
        service_handle: attached_service[:service_handle],
        type_path: attached_service[:type_path],
        publisher_namespace: attached_service[:publisher_namespace]
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