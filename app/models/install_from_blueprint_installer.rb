class InstallFromBlueprintInstaller

  include Engines::Api

  def initialize(install_from_blueprint)
    @install_from_blueprint = install_from_blueprint
  end
  
  def install
p :INSTALLING
p engine_build_params
    result = engines_api.build_engine engine_build_params
p :INSTALLING_RESULT
p result
    if result.was_success
      persist_application
    end
    result
  end

  def persist_application
    Application.where(container_name: @install_from_blueprint.application.container_name).first_or_create.tap do |application|
      application.assign_attributes(application_display_properties_attributes: { installer_icon_url: @install_from_blueprint.installer_icon_url })
      application.application_display_properties.set_defaults
      application.save
    end
  end

  def engine_build_params
    @engine_build_params ||= {
      engine_name: @install_from_blueprint.application.container_name,
      host_name: @install_from_blueprint.application.application_network_properties.host_name,
      domain_name: @install_from_blueprint.application.application_network_properties.domain_name,
      http_protocol: @install_from_blueprint.application.application_network_properties.http_protocol.to_s,
      memory: @install_from_blueprint.application.application_resources_properties.memory,
      variables: variables_params,
      attached_services: application_service_connectors_params,
      repository_url: @install_from_blueprint.repository_url
    }
  end
  
  def variables_params
    {}.tap do |result|
      @install_from_blueprint.application.variables.each do |variable|
        result[variable.name] = variable.value
      end
    end
  end

  def application_service_connectors_params
    @install_from_blueprint.application.application_service_connectors.map do |application_service_connector|
      application_service_connector.application_install_connect_params
    end
  end

end

