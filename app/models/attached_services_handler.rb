class AttachedServicesHandler < ActiveRecord::Base

  belongs_to :software
  has_many :attached_services

  accepts_nested_attributes_for :attached_services

  def load_attached_services
    # attached_services.delete_all
    attached_services.build(attached_services_params_from_api_data)
  end

  def available_services
    EnginesSoftware.available_services(software.engine_name) #[:services]
  end

private

  def attached_services_params_from_api_data

    result = []
    EnginesSoftware.attached_services(software.engine_name).each do |attached_service_type, attached_service_type_detail|
      attached_service_type_detail.each do |attached_service_provider_detail|
        attached_service_provider_detail.each do |attached_service_provider, attached_services_detail|

          service_detail = EnginesAttachedService.service_detail(
            service_provider: attached_service_provider,
            service_type: attached_service_type)

          attached_services_detail.each do |attached_service|
            name = attached_service[:name]
            result << {
              description: service_detail[:description],
              title: service_detail[:title],
              name: name,
              service_type: attached_service_type,
              service_provider: attached_service_provider
            }
          end
        end
      end
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