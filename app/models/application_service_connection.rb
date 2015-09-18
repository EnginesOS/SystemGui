# class ApplicationServiceConnectNew
#   
#   
# end
# 
# 
# 
# class ApplicationService < ActiveRecord::Base
# 
  # include Engines::Api
# 
  # attr_accessor(
    # :type_path,
    # :publisher_namespace,
    # :service_container_name,
    # :service_handle,
    # :create_type,
    # :container_type,
    # :service_action,
    # :orphan_service,
    # :active_service,
    # :new_record,
    # :engines_api_error
    # )
#  
  # belongs_to :application
  # has_many :application_subservices, dependent: :destroy
  # has_many :variables, as: :variable_consumer, dependent: :destroy
  # accepts_nested_attributes_for :application_subservices
  # accepts_nested_attributes_for :variables
#   
  # def service
    # @service_engine ||= Service.new(container_name: service_container_name)
  # end
#   
  # # def build_select_create_type
    # # set_service_detail
  # # end
# 
  # def build_new
    # self.new_record = true
    # variables.build(new_variables_params)
  # end
# 
  # def new_variables_params
    # if create_type.to_sym == :new
      # variable_definitions
    # elsif create_type.to_sym == :active
      # new_active
    # elsif create_type.to_sym == :orphan
      # new_orphan
    # end
  # end
# 
  # def variable_definitions_for_mutable_variables
    # variable_definitions
  # end
# 
  # def new_active
#     
# p :variable_definitions
# p variable_definitions    
#     
    # variable_definitions
  # end
# 
  # def new_orphan
    # variable_definitions
  # end
# 
#   
  # def build_edit
    # self.new_record = false
    # build_variables_for_current
  # end
# 
  # def build_show
    # build_variables_for_current
  # end
# 
  # def build_variables_for_new
  # end
# 
  # def build_variables_for_current
    # variables.build(variable_definitions)
    # load_variable_values
  # end
# 
  # def load_variable_values
    # variables.each do |variable|
      # load_value_for variable
    # end
  # end
#     
  # def load_value_for(variable)
    # variable.value = variable_values[variable.name.to_sym]
  # end
#   
  # def variable_values
    # service_hash[:variables]
  # end
#   
  # def create
    # valid? && connect_service
  # end
#   
  # def update
    # valid? && update_attached_service
  # end
#   
  # def destroy
    # remove_attached_service
  # end
# 
  # def remove_attached_service
    # result = engines_api.dettach_service(connect_new_service_params)
    # if !result.was_success
      # @engines_api_error = (result.result_mesg.present? ? result.result_mesg : 
        # "Unable to remove connected service. No result message given by engines api. Called 'dettach_service' with params: #{connect_new_service_params}")
    # end
    # result.was_success
  # end
#   
  # def connect_service
    # if create_type.to_sym == :new
      # connect_new_service
    # else
      # connect_existing_service
    # end
  # end
#   
  # def connect_existing_service
    # engines_api.attach_existing_service_to_engine(connect_existing_service_params)  
  # end
#   
  # def connect_new_service
    # result = engines_api.attach_service(connect_new_service_params)
    # if !result.was_success
      # @engines_api_error = (result.result_mesg.present? ? result.result_mesg : 
        # "Unable to create attached service. No result message given by engines api. Called 'attach_service' with params: #{connect_new_service_params}")
    # end
    # result.was_success
  # end
#   
  # def update_attached_service
    # result = engines_api.update_attached_service(connect_new_service_params)
    # if !result.was_success
      # @engines_api_error = (result.result_mesg.present? ? result.result_mesg : 
        # "Unable to edit connected service. No result message given by engines api. Called 'update_attached_service' with params: #{connect_new_service_params}")
    # end
    # result.was_success
  # end
#   
  # def perform_action
    # action = service_action.to_sym
    # if action == :register
      # api_method = :register_attached_service
    # elsif action == :deregister
      # api_method = :deregister_attached_service
    # elsif action == :reregister
      # api_method = :reregister_attached_service
    # end
    # result = engines_api.send(api_method, connect_new_service_params)
    # if !result.was_success
      # @engines_api_error = "Unable to #{action} connected service. " + (result.result_mesg.present? ? result.result_mesg : "No result message given by engines api. Called '#{api_method}' with params: #{connect_new_service_params}")
    # end
    # result.was_success    
  # end
#    
  # def variables_params
    # {}.tap do |result|
      # variables.each do |variable|
        # value = variable.value
        # if (variable.field_type.to_sym == :boolean || variable.field_type.to_sym == :checkbox)
          # value = true if value == "1"
          # value = false if value == "0"
        # end
        # result[variable.name.to_sym] = value
      # end
    # end
  # end
# 
  # def identification_params
    # {
        # application_name: application.container_name,
        # application_service: {
          # type_path: type_path,
          # publisher_namespace: publisher_namespace,
          # service_handle: service_handle,
          # container_type: container_type,
          # service_container_name: service_container_name }
    # }
  # end
# 
  # def connect_new_service_params
    # {
      # parent_engine: application.container_name,
      # type_path: type_path,
      # publisher_namespace: publisher_namespace,
      # service_handle: service_handle,
      # container_type: container_type,
      # service_container_name: service_container_name,
      # variables: variables_params
    # }
  # end
# 
  # def new_record?
    # new_record == true
  # end
# 
#   
  # def service_hash
    # @service_detail ||= engines_api.retrieve_service_hash(
                                  # parent_engine: application.container_name,
                                  # publisher_namespace: publisher_namespace,
                                  # type_path: type_path,
                                  # service_container_name: service_container_name,
                                  # container_type: container_type,
                                  # service_handle: service_handle)
# p :service_hash
# p @service_hash
#                                  
#                                  
  # end
# 
  # # def set_service_hash_for_connect_to_existing
    # # @service_hash = engines_api.retrieve_service_hash(
                                  # # parent_engine: application.container_name,
                                  # # publisher_namespace: publisher_namespace,
                                  # # type_path: type_path,
                                  # # service_handle: service_handle)
  # # end
# 
# 
  # def available_subservices
    # engines_api.load_avail_services_for_type(type_path)
  # end
# 
  # def templated_software_service_definition
    # @templated_software_service_definition ||= engines_api.templated_software_service_definition(
                        # parent_engine: application.container_name,
                        # publisher_namespace: publisher_namespace,
                        # type_path: type_path)
  # end
#   
  # def service_detail
    # @service_detail ||= if templated_software_service_definition.is_a?(EnginesOSapiResult)
      # engines_api_error = templated_software_service_definition.result_mesg
      # {}
    # else
      # templated_software_service_definition
    # end
  # end
#   
  # # def test
    # # engines_api.software_service_definition(
                        # # publisher_namespace: publisher_namespace,
                        # # type_path: type_path)
  # # end
# 
  # # def set_service_detail_for_current
    # # result = engines_api.software_service_definition(
                        # # publisher_namespace: publisher_namespace,
                        # # type_path: type_path)
    # # @service_detail = if result.is_a?(EnginesOSapiResult)
      # # engines_api_error = result.result_mesg
      # # {}
    # # else
    # # result
    # # end
  # # end
# 
# 
# 
  # def variable_definitions
    # @variable_definitions ||= service_detail.present? ? service_detail[:consumer_params].values : []
  # end    
# 
  # def variable_definitions_mutable_only
#     
# p :variable_definitions
# p variable_definitions    
#     
#     
    # @variable_definitions_mutable_only ||= variable_definitions
  # end
#   
  # def new_connected_service_parent_engine
    # if create_type.to_sym = :new
    # elsif create_type.to_sym = :active
      # active_service.split(' - ').first
    # elsif create_type.to_sym = :orphan
      # orphan_service.split(' - ').first
    # end
  # end    
# 
  # def new_connected_service_handle
    # if create_type.to_sym = :new
    # elsif create_type.to_sym = :active
      # active_service.split(' - ').last
    # elsif create_type.to_sym = :orphan
      # orphan_service.split(' - ').last
    # end
  # end
# 
# 
# 
  # def connect_existing_service_params
    # {}.tap do |result|
      # result[:publisher_namespace] = publisher_namespace
      # result[:type_path] = type_path
      # type = create_type.to_sym
      # result[:create_type] = type.to_s
      # case type
      # when :active
        # active_service_input = active_service.split(" - ")
        # result[:parent_engine] = active_service_input[0]
        # result[:service_handle] = (active_service_input[1] || active_service_input[0])
      # when :orphan
        # orphan_service_input = orphan_service.split(" - ")
        # result[:parent_engine] = orphan_service_input[0]
        # result[:service_handle] = (orphan_service_input[1] || orphan_service_input[0]) 
      # end
    # end
  # end
#   
# 
# 
# end
