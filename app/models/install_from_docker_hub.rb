class InstallFromDockerHub < ActiveRecord::Base

  include Engines::Api

  belongs_to :application
  accepts_nested_attributes_for :application
  
  attr_accessor(
    :docker_image,
    :type,
    :run_as_user,
    :run_command,
    :new_application_service_publisher_namespace,
    :new_application_service_type_path,
    :new_environment_variable,
    :new_eport,
    :scroll_form_to )

  validate :docker_image_validation

  def self.build_new
    new.tap do |new_install|
      new_install.type = "Software"
      new_install.build_application
    end
  end

  def self.build_configuration(install_from_docker_hub_params)
    new(install_from_docker_hub_params).tap do |result|
      result.type = 'Software'
      result.application.build_application_resources_properties
      result.application.build_application_network_properties(http_protocol: :http_https)
      result.application.application_service_connectors.each(&:load_application_service_connector_configuration_variables)
    end
  end
  
  def new_record?
    true
  end

  def ready_to_install?
    valid?
  end

  def ready_to_configure?
    !load_new_form_elements && valid?
  end

  def load_new_form_elements
    if new_application_service_publisher_namespace.present? && new_application_service_type_path.present?
      build_application unless application
      application.application_service_connectors.
        build(publisher_namespace: new_application_service_publisher_namespace,
              type_path: new_application_service_type_path,
              application_service_connector_type_attributes: {create_type: :new})
      self.new_application_service_type_path = nil
      self.new_application_service_publisher_namespace = nil
      self.scroll_form_to = :application_service_fields
      true
    elsif new_environment_variable.present?
      build_application unless application
      application.variables.build
      self.scroll_form_to = :environment_variable_fields
      self.new_environment_variable = nil
      true
    elsif new_eport.present?
      build_application unless application
      application.eports.build(protocol: 'TCP')
      self.scroll_form_to = :eport_fields
      self.new_eport = nil
      true
    else
      self.scroll_form_to = nil
      false
    end
  end

  def new_configuration_params
    {
      install_from_docker_hub: {
        docker_image: docker_image,
        application_attributes: {
          container_name: application.container_name,
          application_service_connectors_attributes: new_configuration_application_application_service_connectors_params,
          variables_attributes: new_configuration_application_variables_params,
          eports_attributes: new_configuration_application_eports_params
        }
      }
    }
  end

  def new_configuration_application_application_service_connectors_params
    result = {}
    application.application_service_connectors.map.with_index do |application_service_connector, i|
      result[i.to_s] = {
        type_path: application_service_connector.type_path,
        publisher_namespace: application_service_connector.publisher_namespace,
        parent_engine_name: application.container_name,
        application_service_connector_configuration_attributes: {
          create_type: application_service_connector.application_service_connector_type.create_type,
          existing_service: application_service_connector.application_service_connector_type.existing_service_params_json
        }
      }
    end
    result
  end
  
  def new_configuration_application_variables_params
    result = {}
    application.variables.map.with_index do |variable, i|
      result[i.to_s] = { name: variable.name, value: variable.value }
    end
    result
  end
  
  def new_configuration_application_eports_params
    result = {}
    application.eports.map.with_index do |eport, i|
      result[i.to_s] = { name: eport.name, internal_port: eport.internal_port, external_port: eport.external_port, protocol: eport.protocol.to_s.downcase.underscore }
    end
    result
  end
  
  def installation_params
    {
      engine_name: application.container_name,
      memory: application.application_resources_properties.memory,
      docker_image: docker_image,
      run_as_user: run_as_user,
      run_command: run_command,
      variables: variables_installation_params,
      services: services_installation_params,
      eports: eports_installation_params
    }
  end

  def variables_installation_params
    {}.tap do |result|
      application.variables.each do |variable|
        result[variable.name.to_sym] = variable.value
      end
    end
  end
  
  def services_installation_params
    application.application_service_connectors.map do |service|
      {}.tap do |result|
        type = service.application_service_connector_configuration.create_type.to_sym
        result[:create_type] = service.application_service_connector_configuration.create_type.to_s
        result[:publisher_namespace] = service.publisher_namespace
        result[:type_path] = service.type_path
        result[:variables] = service.application_service_connector_configuration.variable_values_params
        result[:existing_service] = service.application_service_connector_configuration.existing_service_params
      end
    end
  end

  def eports_installation_params
    application.eports.map do |eport|
      {}.tap do |result|
        result[:name] = eport.name
        result[:internal_port] = eport.internal_port
        result[:external_port] = eport.external_port
        result[:tcp] = eport.protocol.include?('TCP')
        result[:udp] = eport.protocol.include?('UDP')
      end
    end
  end
  
  def install
    engines_api.build_engine_from_docker_image(@install_from_docker_hub.installation_params)
  end

  def available_services
    engines_api.load_avail_services_for_type 'ManagedEngine'
  end

  def docker_image_validation
    if docker_image.blank?
      errors.add(:docker_image, ["Docker image source", "is required"])
    end
  end
  
end