class ApplicationInstallation < ActiveRecord::Base

  include Engines::Api

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
      application_service.connect_existing_service_params
    end
  end

end

