class InstallFromBlueprint < ActiveRecord::Base

  # require 'json'
  include Engines::Api

  attr_accessor(:license_terms_and_conditions, :advanced_selected, :repository_url, :installer_icon_url)
    
  belongs_to :application
  accepts_nested_attributes_for :application

  validate :license_terms_and_conditions_accepted_validation

  def build_new
    assign_attributes(new_application_attributes)
  end

  # def self.new(params)
    # super(params).tap{|new_object| new_object.assign_attributes(new_application_attributes)}
  # end

  def icon_url
    installer_icon_url || blueprint_software[:icon_url]
  end

  def description
    blueprint_software[:description]
  end

  def title
    blueprint_software[:short_title]
  end

  def license_label
    blueprint_software[:license_label] || blueprint_software[:license_name]
  end

  def license_sourceurl
    blueprint_software[:license_sourceurl]
  end
  
  def resolved_repository_url
    repository_url
  end

  def browser_target
    license_label.underscore
  end

  def default_name
    blueprint_software[:name].to_s.gsub('-', '').to_s.gsub('_', '')
  end

  def blueprint
    @blueprint ||= Engines::Repository.new(resolved_repository_url).blueprint
  end

  def blueprint_software
    @blueprint_software ||= if blueprint
                              blueprint[:software].symbolize_keys
                            else
                              {}
                            end
  end

  def default_http_protocol
    blueprint_protocol = blueprint_software[:http_protocol].to_s.downcase.sub('only', '').sub('and', '').strip.gsub(/[ ]./, '_').to_sym
    blueprint_protocol = :http_https if blueprint_protocol == :https_http
    [:http, :https, :http_https].include?(blueprint_protocol) ? blueprint_protocol : :http_https
  end

  def mandatory_fields_present?
    application.variables.map{|v| v.mandatory }.any?
  end

  def new_application_attributes
    { 
      application_attributes: {
          container_name: unique_application_name,
          variables_attributes: blueprint_software[:variables] || [],
          application_network_properties_attributes: {
            host_name: unique_host_name,
            domain_name: DomainSettings.engines_default_domain,
            http_protocol: default_http_protocol
          },
          application_resources_properties_attributes: {
            required_memory: blueprint_software[:required_memory],
            memory: blueprint_software[:recommended_memory] || blueprint_software[:required_memory]
          },
          application_services_attributes: load_application_services_params || []
        }
     }
  end

  def load_application_services_params
    service_configurations = blueprint_software[:service_configurations]
    if service_configurations.present?
      return service_configurations.map do |service_configuration|
        service_configuration.symbolize_keys!
        params =  {
                    publisher_namespace: service_configuration[:publisher_namespace],
                    type_path: service_configuration[:type_path],
                    create_type: :new
                  }
        if ApplicationService.new(params).persistant
          params              
        end
      end.compact
    else
      return {}
    end
  end

  def license_terms_and_conditions_accepted_validation
    if license_terms_and_conditions != "1"
      errors.add(:license_terms_and_conditions, ["License", "must be accepted"])
    end
  end

  def unique_host_name
    default_host_name = default_name
    unique_host_name_candidate = default_host_name
    index = 2
    while existing_host_names.include? unique_host_name_candidate do
      unique_host_name_candidate = default_host_name + index.to_s
      index += 1
    end
    unique_host_name_candidate
  end

  def existing_engine_names
    @existing_engine_names ||= (engines_api.reserved_engine_names || [])
  end
  
  def existing_host_names
    @existing_host_names ||= (engines_api.reserved_hostnames || [])
  end

  def unique_application_name
    unique_application_name_candidate = default_name
    index = 2
    while existing_engine_names.include? unique_application_name_candidate do
      unique_application_name_candidate = default_name + index.to_s
      index += 1
    end
    unique_application_name_candidate
  end
  
  
  def install
    valid? && ApplicationInstallation.new(application_installation_params).install
  end
  
  def application_installation_params
    { application_attributes:
        { container_name: application.container_name,
          variables_attributes: application_variables_attributes,
          application_network_properties_attributes:
            { host_name: application.application_network_properties.host_name,
              domain_name: application.application_network_properties.domain_name,
              http_protocol: application.application_network_properties.http_protocol
            },
          application_resources_properties_attributes:
            { memory: application.application_resources_properties.memory },
          application_display_properties_attributes:
            { installer_icon_url: installer_icon_url },
          application_services_attributes: application_services_attributes,
          install_from_blueprint_attributes:
            { repository_url: repository_url }
        }
     }
  end
  
  def application_variables_attributes
    application.variables.map{|variable| {name: variable.name, value: variable.value}}
  end

  def application_services_attributes
    application.application_services.map do |application_service|
      { type_path: application_service.type_path,
        publisher_namespace: application_service.publisher_namespace,
        # service_container_name: application_service.service_container_name,
        # service_handle: application_service.service_handle,
        create_type: application_service.create_type,
        # container_type: application_service.container_type,
        # service_action: application_service.service_action,
        orphan_service: application_service.orphan_service,
        active_service: application_service.active_service,
      }
    end
  end
  
  
  
      # {
      # container_name: unique_application_name,
      # variables_attributes: blueprint_software[:variables] || [],
      # application_network_properties_attributes: {
        # host_name: unique_host_name,
        # domain_name: DomainSettings.engines_default_domain,
        # http_protocol: default_http_protocol
      # },
      # application_resources_properties_attributes: {
        # required_memory: blueprint_software[:required_memory],
        # memory: blueprint_software[:recommended_memory] || blueprint_software[:required_memory]
      # },
      # application_services_attributes: load_application_services_params || []
    # }
  

end

