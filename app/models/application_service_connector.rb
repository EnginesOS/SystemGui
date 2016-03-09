class ApplicationServiceConnector < ActiveRecord::Base

  include Engines::Api

  attr_accessor :type_path, :publisher_namespace, :parent_engine_name

  belongs_to :application
  has_one :application_service_connector_type
  has_one :application_service_connector_configuration

  accepts_nested_attributes_for :application_service_connector_type
  accepts_nested_attributes_for :application_service_connector_configuration

  def title
    service_detail[:title] || '?'
  end

  def description
    service_detail[:description] || '?'
  end

  def service_detail
    if service_detail_call.is_a? Hash
      service_detail_call
    else
      {}
    end
  end
    
  def service_detail_call
    @service_detail_call ||= engines_api.software_service_definition(
                                      publisher_namespace: publisher_namespace,
                                      type_path: type_path)
  end

  def templated_service_detail 
    @templated_service_detail ||= engines_api.templated_software_service_definition(
                                                parent_engine: parent_engine_name || application.container_name,
                                                publisher_namespace: publisher_namespace,
                                                type_path: type_path)
  end

  def load_application_service_connector_configuration_variables
    application_service_connector_configuration.variables.build(application_service_connector_configuration_variables_params)
  end

  def application_service_connector_configuration_variables_params
    case application_service_connector_configuration.create_type.to_sym
    when :new
      templated_variables_params
    else
      mutable_variables_params
    end
  end
  
  def templated_variables_params
    templated_service_detail[:consumer_params].values
  end
  
  def mutable_variables_params
    templated_variables_params.reject{|variable_params| variable_params[:immutable] == true}
  end
  
  def no_existing_connections?
    !service_detail[:persistent] || (connectable_active_connected_services.empty? && connectable_orphan_connected_services.empty?)
  end
  
  def connectable_active_connected_services
    result = engines_api.get_registered_against_service(type_path: type_path, publisher_namespace: publisher_namespace)
    result = [] unless result.is_a? Array
    result.map do |service_definition|
      service_definition = service_definition_handle_params(service_definition)
      if service_definition[:parent_engine] == service_definition[:service_handle]
        [service_definition[:parent_engine], service_definition.to_json]
      else
        ["#{service_definition[:parent_engine]} - #{service_definition[:service_handle]}", service_definition.to_json]
      end
    end
  end

  def connectable_orphan_connected_services
    result = engines_api.get_orphaned_services(type_path: type_path, publisher_namespace: publisher_namespace)
    result = [] unless result.is_a? Array
    result.map do |service_definition|
      service_definition = service_definition_handle_params(service_definition)
      if service_definition[:parent_engine] == service_definition[:service_handle]
        [service_definition[:parent_engine], service_definition.to_json]
      else
        ["#{service_definition[:parent_engine]} - #{service_definition[:service_handle]}", service_definition.to_json]
      end
    end
  end

  def service_definition_handle_params(service_definition)
    service_definition = service_definition.select do |k,v|
      [ :service_handle,
        :service_container_name,
        :parent_engine,
        :container_type].include? k.to_sym
    end
  end


  def connector_configuration_attributes
    {
      application_name: application.container_name,
      application_service_connector: {
        type_path: type_path,
        publisher_namespace: publisher_namespace,
        application_service_connector_configuration_attributes: {
          create_type: application_service_connector_type ? application_service_connector_type.create_type : :new,
          existing_service: application_service_connector_type ? application_service_connector_type.existing_service_params_json : ''
        }
      }
    }
  end

  def connect
    valid? &&
    if application_service_connector_configuration.create_type.to_sym == :new
      connect_new_application_service
    else
      connect_existing_application_service
    end
  end
  
  def connect_new_application_service
    result = engines_api.attach_service(connect_params)
    if !result.was_success
      errors.add(:base, "Unable to connect service. " + 
                            (result.result_mesg.present? ? result.result_mesg[0..500] : 
                                        "No result message given by engines api."))
    end
    result.was_success
  end
  
  def connect_existing_application_service
    result = engines_api.attach_existing_service_to_engine(connect_params)
    if !result.was_success
      errors.add(:base, "Unable to connect service. " + 
                            (result.result_mesg.present? ? result.result_mesg[0..500] : 
                                        "No result message given by engines api."))
    end
    result.was_success
  end

  def connect_params
    {
      parent_engine: application.container_name,
      type_path: type_path,
      publisher_namespace: publisher_namespace,
      create_type: application_service_connector_configuration.create_type,
      service_handle: application_service_connector_configuration.service_handle,
      container_type: application.container_type,
      service_container_name: application_service_connector_configuration.service_container_name,
      variables: application_service_connector_configuration.variable_values_params
    }
  end

  def application_install_connect_params
    {
      type_path: type_path,
      publisher_namespace: publisher_namespace,
      create_type: application_service_connector_type.create_type.to_sym == :new ? nil : application_service_connector_type.create_type,
      parent_engine: application_service_connector_type.existing_service_params[:parent_engine],
      container_type: application_service_connector_type.existing_service_params[:container_type],
      service_handle: application_service_connector_type.existing_service_params[:service_handle],
      service_container_name: application_service_connector_type.existing_service_params[:service_container_name]
    }
  end

end