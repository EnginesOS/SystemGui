class ApplicationService < ActiveRecord::Base

  include Engines::Api
  
  attr_accessor :type_path,
                :publisher_namespace,
                :create_type,
                :orphan_service,
                :active_service,
                :service_handle,
                :container_type,
                :service_container_name,
                :service_action,
                :engines_api_error

  belongs_to :application
  has_many :variables, as: :variable_consumer, dependent: :destroy
  has_many :application_subservices, dependent: :destroy

  accepts_nested_attributes_for :variables
  
  # def initialize(params)
    # @application_name = params[:application_name]
    # @type_path = params[:type_path]
    # @publisher_namespace = params[:publisher_namespace]
  # end
  
  def connect_service
    valid? && api_connect_service
  end

  def api_connect_service
    if create_type.to_sym == :new
      api_connect_new_service
    else
      api_connect_existing_service
    end
  end
  
  def api_connect_new_service
    result = engines_api.attach_service(connected_service_persist_params)
    if !result.was_success
      @engines_api_error = "Unable to connect service. " + 
                            (result.result_mesg.present? ? result.result_mesg[0..500] : 
                                        "No result message given by engines api.")
    end
    result.was_success
  end
  
  def api_connect_existing_service
    result = engines_api.attach_existing_service_to_engine(connected_service_persist_params)
    if !result.was_success
      @engines_api_error = "Unable to connect service. " + 
                            (result.result_mesg.present? ? result.result_mesg[0..500] : 
                                        "No result message given by engines api.")
    end
    result.was_success
  end
  
  def attachable_active_attached_services
    engines_api.get_registered_against_service(type_path: type_path, publisher_namespace: publisher_namespace).map do |service|
      if service[:parent_engine] == service[:service_handle]
        service[:parent_engine]
      else
        "#{service[:parent_engine]} - #{service[:service_handle]}"
      end
    end
  end

  def attachable_orphaned_attached_services
    engines_api.get_orphaned_services(type_path: type_path, publisher_namespace: publisher_namespace).map do |service|
      if service[:parent_engine] == service[:service_handle]
        service[:parent_engine]
      else
        "#{service[:parent_engine]} - #{service[:service_handle]}"
      end
    end
  end
  
  def new_connect_service_params
    {
      application_name: application.container_name,
      application_service: {
        type_path: type_path,
        publisher_namespace: publisher_namespace,
        create_type: create_type,
        orphan_service: orphan_service,
        active_service: active_service
      }
    }    
  end
  
  def connected_service_persist_params
    {
      parent_engine: application.container_name,
      type_path: type_path,
      publisher_namespace: publisher_namespace,
      service_handle: service_handle,
      container_type: container_type,
      service_container_name: service_container_name,
      variables: variables_values_params
    }
  end
  
  def variables_values_params
    {}.tap do |result|
      variables.each do |variable|
        value = variable.value
        if (variable.field_type.to_sym == :boolean || variable.field_type.to_sym == :checkbox)
          value = true if value == "1"
          value = false if value == "0"
        end
        result[variable.name.to_sym] = value
      end
    end
  end
  
  def mutable_variables_params_for_connect_new_service
    templated_variables_params_for_connect_new_service.reject{|variable_params| variable_params[:immutable] == true}
  end
  
  def variables_params_for_connect_service
    templated_variables_params_for_connect_new_service.map do |variable_params|
      variable_params[:value] = variables_values[variable_params[:name].to_sym]
      variable_params
    end
  end
  
  def variables_values
    @variables_values ||= api_service_hash[:variables]
  end
  
  def api_service_hash
    @api_service_hash ||= engines_api.retrieve_service_hash(
                                  parent_engine: application.container_name,
                                  publisher_namespace: publisher_namespace,
                                  type_path: type_path,
                                  service_container_name: service_container_name,
                                  container_type: container_type,
                                  service_handle: service_handle)
  end

  def parent_engine_for_existing_service
    if create_type.to_sym == :active
      active_service.split(' - ').first
    elsif create_type.to_sym == :orphan
      orphan_service.split(' - ').first
    else
      nil
    end
  end
  
  def service_handle_for_existing_service
    if create_type.to_sym == :active
      active_service.split(' - ').last
    elsif create_type.to_sym == :orphan
      orphan_service.split(' - ').last
    else
      nil
    end
  end  
  
  def new_record?
    @new_record
  end
  
  def build_for_edit
    load_variables
    @new_record = false
  end
  
  def load_variables
    if create_type.present?
      case create_type.to_sym
      when :new
        variables.build(templated_variables_params_for_connect_new_service)
      when :active
        variables.build(mutable_variables_params_for_connect_new_service)
      when :orphan
        variables.build(mutable_variables_params_for_connect_new_service)
      end
    else
      variables.build(variables_params_for_connect_service)
    end
  end
  
  def available_subservices
    engines_api.load_avail_services_for_type(type_path)
  end

  def service_detail 
    @service_detail ||= engines_api.software_service_definition(
                                      publisher_namespace: publisher_namespace,
                                      type_path: type_path)
  end
  
  def templated_service_detail 
    @templated_service_detail ||= engines_api.templated_software_service_definition(
                                                parent_engine: application.container_name,
                                                publisher_namespace: publisher_namespace,
                                                type_path: type_path)
  end
  
  def templated_variables_params_for_connect_new_service
    templated_service_detail[:consumer_params].values
  end
  
  # def raw_variables_params_for_connect_new_service
    # service_detail[:consumer_params].values
  # end 
  
  def shareable
    service_detail[:shareable] || false
  end
  
  def title
    service_detail[:title] || '?'
  end
  
  def description
    service_detail[:description] || '?'
  end

  def persistant
    service_detail[:persistant] || false
  end


  def immutable
    !mutable
  end
  
  def mutable
    service_detail[:immutable] != true
  end
  
  def nothing_to_share
    !shareable || (attachable_active_attached_services.empty? && attachable_orphaned_attached_services.empty?)
  end
  
  def handle_params
    {
        application_name: application.container_name,
        application_service: {
          type_path: type_path,
          publisher_namespace: publisher_namespace,
          service_handle: service_handle,
          container_type: container_type,
          service_container_name: service_container_name }
    }
  end

  def update
    valid? && update_connected_service
  end
  
  def destroy
    remove_connected_service
  end

  def remove_connected_service
    result = engines_api.dettach_service(handle_params)
    if !result.was_success
      @engines_api_error = "Unable to remove connected service. " + 
                            (result.result_mesg.present? ? result.result_mesg[0..500] : 
                                        "No result message given by engines api.")
    end
    result.was_success
  end

  def update_connected_service
    result = engines_api.update_attached_service(connected_service_persist_params)
    if !result.was_success
      @engines_api_error = "Unable to update connected service. " + 
                            (result.result_mesg.present? ? result.result_mesg[0..500] : 
                                        "No result message given by engines api.")
    end
    result.was_success
  end
  
  def perform_action
    action = service_action.to_sym
    if action == :register
      api_method = :register_attached_service
    elsif action == :deregister
      api_method = :deregister_attached_service
    elsif action == :reregister
      api_method = :reregister_attached_service
    end
    result = engines_api.send(api_method, handle_params)
    if !result.was_success
      @engines_api_error = "Unable to #{action} connected service. " + 
                            (result.result_mesg.present? ? result.result_mesg[0..500] : 
                                        "No result message given by engines api.")
    end
    result.was_success    
  end
   
  def connect_existing_service_params
    {}.tap do |result|
      result[:publisher_namespace] = publisher_namespace
      result[:type_path] = type_path
      type = create_type.to_sym
      result[:create_type] = type.to_s
      case type
      when :active
        active_service_input = active_service.split(" - ")
        result[:parent_engine] = active_service_input[0]
        result[:service_handle] = (active_service_input[1] || active_service_input[0])
      when :orphan
        orphan_service_input = orphan_service.split(" - ")
        result[:parent_engine] = orphan_service_input[0]
        result[:service_handle] = (orphan_service_input[1] || orphan_service_input[0]) 
      end
    end
  end

end
