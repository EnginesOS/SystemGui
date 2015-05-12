# module Engines::ApplicationService
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
  # def available_subservices
    # available_services_hash[:subservices][type_path]
  # end
# 
# ######
# 
  # def service_detail
    # @service_detail ||= engines_api.software_service_definition(
                        # publisher_namespace: publisher_namespace,
                        # type_path: type_path)
  # end
# 
# #####
# 
  # def title
    # service_detail[:title]
  # end
#   
  # def description
    # service_detail[:description]
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
# 
# 
# 
  # # def registered_subservices_hash
    # # @application.registered_services_hash
  # # end
# # 
  # # def registered_subservices
    # # []
    # # # [].tap do |result|
      # # # registered_services_hash.each do |registered_service|
        # # # result << Engines::Applications::ServiceRegistration.new(self).build(registered_service)
      # # # end
    # # # end
  # # end
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
# 
 # # def persistant_attached_services
      # # engines_api.get_engine_persistant_services(container_name: container_name)
    # # end
#     
      # # def attached_services
      # # [].tap do |result|
        # # attached_services_hash.each do |registered_service_params|
          # # result << Engines::Applications::Service.new(self).build(registered_service_params)
        # # end
      # # end
    # # end
# 
    # # def new_service_for(publisher_namespace, type_path)
      # # Engines::Applications::Service.new(self).build(publisher_namespace: publisher_namespace, type_path: type_path)
    # # end   
#     
# 
  # # def self.register_service params
    # # engines_api.attach_service params
  # # end
# # 
  # # def self.deregister_service params
    # # engines_api.detach_service params
  # # end
# # 
  # # def self.register_subservice params
    # # engines_api.attach_subservice params
  # # end
# # 
  # # def self.register_subservice params
    # # engines_api.detach_subservice params
  # # end
# # 
  # # def self.reregister_service params
    # # engines_api.reregister_service params
  # # end
# # 
  # # def self.attached_subservices(service_class, service_name)
    # # engines_api.list_attached_services_for(service_class, service_name)
  # # end
# # 
  # # def self.available_services(engine_name)
    # # engines_api.list_avail_services_for(EnginesSoftware.engines_software(engine_name))
  # # end
# # 
  # # def self.delete_orphaned_service(params)
    # # engines_api.delete_orphaned_service params
  # # end
# # 
  # # def self.docker_hub_install_available_services
    # # # engines_api.list_avail_services_for_type('ManagedEngine')
    # # engines_api.list_avail_services_for(EnginesSoftware.engines_software('phpmyadmin'))
  # # end
# # 
  # # def self.service_is_persistant(type_path, publisher_namespace)
    # # true
  # # # || SoftwareServiceDefinition.is_persistant?(
  # # # publisher_namespace: publisher_namespace,
  # # # type_path: type_path)
  # # end
# # 
  # # def self.orphaned_services(type_path, publisher_namespace)
    # # engines_api.get_orphaned_services(type_path: type_path, publisher_namespace: publisher_namespace)
  # # end
# # 
  # # def self.active_attached_services(type_path, publisher_namespace)
    # # engines_api.get_registered_against_service(type_path: type_path, publisher_namespace: publisher_namespace)
  # # end
# # 
# # 
# # 
# 
# # 
# # class AttachedServicesHandler < ActiveRecord::Base
# # 
  # # belongs_to :software
  # # has_many :attached_services
# # 
  # # accepts_nested_attributes_for :attached_services
# # 
  # # def load_attached_services
    # # attached_services.build(attached_services_params_from_api)
  # # end
# #   
  # # def load_attached_services_details
    # # attached_services.each do |attached_service|
      # # service_detail = EnginesAttachedService.service_detail_for(attached_service.type_path, attached_service.publisher_namespace)
      # # if service_detail.kind_of?(EnginesOSapiResult)
        # # service_detail = {title: "Error", description: "Could not load service detail."}
      # # end
      # # attached_service.title ||= service_detail[:title]
      # # attached_service.description ||= service_detail[:description]
      # # attached_service.parent_engine ||= service_detail[:parent_engine]
      # # attached_service.service_handle ||= service_detail[:service_handle]
    # # end
  # # end
# # 
# 
# 
# 
    # # def available_services_hash
      # # @available_services_hash ||= engines_api.list_avail_services_for @application
    # # end
# # 
  # # def available_services
    # # available_services_hash[:services]
  # # end
# # 
# #   
  # # def attached_services_from_api
    # # @attached_services_from_api ||= EnginesSoftware.attached_services(software.engine_name)
  # # end
# # 
  # # def service_detail(type_path, publisher_namespace)
    # # result = EnginesAttachedService.service_detail_for(type_path, publisher_namespace)
    # # if result.kind_of?(EnginesOSapiResult)
      # # {}
    # # else
      # # result
    # # end
  # # end
# # 
  # # def docker_hub_install_available_services
    # # EnginesAttachedService.docker_hub_install_available_services[:services]
  # # end
# 
# 
  # # def service_detail(type_path, publisher_namespace)
    # # available_services.find do |service|
      # # service[:type_path] == type_path &&
      # # service[:publisher_namespace] == publisher_namespace
    # # end
  # # end
# 
# 
# 
  # # def volumes
    # # @volumes ||= EnginesSoftware.volumes software.engine_name
  # # end
# 
# 
# 
# 
# # 
# # private
# # 
  # # def attached_services_params_from_api
    # # result = []
    # # attached_services_from_api.each do |attached_service|
      # # service_detail = EnginesAttachedService.service_detail_for(attached_service[:type_path], attached_service[:publisher_namespace])
      # # if service_detail.kind_of?(EnginesOSapiResult)
        # # service_detail = {title: "Error", description: "Could not load service detail."}
      # # end
      # # result << {
        # # description: service_detail[:description],
        # # title: service_detail[:title],
        # # service_handle: attached_service[:service_handle],
        # # type_path: attached_service[:type_path],
        # # publisher_namespace: attached_service[:publisher_namespace],
        # # persistant: attached_service[:persistant],
        # # attached_subservices_attributes: [{title: "hi"}]
      # # }
    # # end
    # # result
  # # end
# # 
# # 
# # 
# 
# 
# 
# #   def params_for_api_update
# #     {
# #       engine_name: engine_name,
# #       services: {hash_key: "dunno"}
# #     }
# 
# #     #     attached_services.map do |attached_service|
# #     #       {
# #     #         service_type: attached_service.service_type,
# #     #         service_provider: 'something_or_other',
# 
# #     #       }
# #     #     end
# 
# #     #   environment_variables:
# #     #     variables.map do |variable|
# #     #       {
# #     #         name: variable.name,
# #     #         value: variable.value
# #     #       }
# #     #     end
# 
# 
# #     # }
# 
# #   end
# 
# 
# 
# 
# end
