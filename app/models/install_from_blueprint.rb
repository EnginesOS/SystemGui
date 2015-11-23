class InstallFromBlueprint < ActiveRecord::Base

  include Engines::Api

  attr_accessor(:license_terms_and_conditions, :advanced_selected, :repository_url, :installer_icon_url, :engines_api_error)
    
  belongs_to :application
  accepts_nested_attributes_for :application

  validate :license_terms_and_conditions_accepted_validation

  def build_new
    assign_attributes(new_application_attributes)
    template_variables
  end

  def icon_url
    installer_icon_url || blueprint_software[:icon_url]
  end

  def description
    blueprint_software[:description]
  end

  def title
    blueprint_software[:short_title] || blueprint_software[:full_title] || default_name
  end

  def license_label
    blueprint_software[:license_label] || blueprint_software[:license_name] || '?'
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
    blueprint_protocol = blueprint_software[:http_protocol].to_s.downcase.sub('only', '').sub('and', '').gsub('_',' ').strip.gsub(' ', '_').to_sym
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
          application_service_connectors_attributes: application_services_connector_params
        }
     }
  end
  
  def template_variables
    application.variables.each do |application_variable|
      application_variable.value = engines_api.get_resolved_string(application_variable.value)
    end 
  end  

  def application_services_connector_params
    service_configurations = blueprint_software[:service_configurations]
    if service_configurations.present?
      return service_configurations.map do |service_configuration|
        service_configuration.symbolize_keys!
        {
          publisher_namespace: service_configuration[:publisher_namespace],
          type_path: service_configuration[:type_path],
          application_service_connector_type_attributes: {
            create_type: :new
          }
        }
      end
    else
      return []
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
    while existing_host_names.include? "#{unique_host_name_candidate.to_s}.#{DomainSettings.engines_default_domain.to_s}" do
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
    valid? && send_install
  end
  
  def send_install
    result = InstallFromBlueprintInstaller.new(self).install
    if result.was_success
      true
    else
      @engines_api_error = "Install failed. " + (result.result_mesg.present? ? result.result_mesg : "No result message given by engines api.")
    end
  end
  
  def engine_build_params
    InstallFromBlueprintInstaller.new(self).engine_build_params
  end

end

