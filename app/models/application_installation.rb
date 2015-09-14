class ApplicationInstallation < ActiveRecord::Base

  # require 'json'
  include Engines::Api

  # attr_accessor :repository_url

  belongs_to :application
  accepts_nested_attributes_for :application
  
  def install
p :INSTALLING
p engine_build_params
    Thread.new do
      result = engines_api.build_engine engine_build_params
      persist_application
    end
  end

  def persist_application
    Application.where(container_name: application.container_name).first_or_create.tap do |application|
      application.assign_attributes(application_display_properties_attributes: { installer_icon_url: installer_icon_url })
      application.application_display_properties.set_defaults
      application.save
    end
  end

  def engine_build_params
    @engine_build_params ||= {
      # software_name: default_name,
      engine_name: application.container_name,
      host_name: application.application_network_properties.host_name,
      domain_name: application.application_network_properties.domain_name,
      http_protocol: application.application_network_properties.http_protocol.to_s,
      memory: application.application_resources_properties.memory,
      variables: engine_build_variables_params,
      attached_services: engine_build_attached_services_params,
      repository_url: application.install_from_blueprint.repository_url
    }
  end
  
  def engine_build_variables_params
    {}.tap do |result|
      application.variables.each do |variable|
        result[variable.name] = variable.value
      end
    end
  end

  def engine_build_attached_services_params
    application.application_services.map do |application_service|
      {}.tap do |result|
        result[:publisher_namespace] = application_service.publisher_namespace
        result[:type_path] = application_service.type_path
        type = application_service.create_type.to_sym
        result[:create_type] = type.to_s
        case type
        when :active
          active_service = application_service.active_service.split(" - ")
          result[:parent_engine] = active_service[0]
          result[:service_handle] = (active_service[1] || active_service[0])
        when :orphan
          orphan_service = application_service.orphan_service.split(" - ")
          result[:parent_engine] = orphan_service[0]
          result[:service_handle] = (orphan_service[1] || orphan_service[0]) 
        end
      end
    end
  end

end

