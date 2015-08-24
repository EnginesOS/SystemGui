class ApplicationInstallation < ActiveRecord::Base

  require 'json'
  include Engines::Api

  attr_accessor(
    :repository_url,
    :gallery_icon_url,
    :software_title,
    :license_terms_and_conditions,
    :advanced_selected
    )
    
  has_one :application
  accepts_nested_attributes_for :application

  validate :license_terms_and_conditions_accepted_validation

  def load_new
    build_application(load_new_application_params)
    @software_title = title
    self
  end

  # def installing_params
    # {
      # repository_url: repository_url,
      # title: software_title,
      # application_name: application.container_name,
      # host_name: application.application_network_properties.host_name,
      # domain_name: application.application_network_properties.domain_name
      # }
  # end

  def icon_url
    blueprint_software[:icon_url] || gallery_icon_url
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
# p :repository_url
# p repository_url
    repository_url # || software_definition[:repository_url]
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

  # # def blueprint_from_gallery
    # # JSON.parse(software_definition[:blueprint]).symbolize_keys
  # # end
#   
  def blueprint_software
    @blueprint_software ||= if blueprint
                              blueprint[:software].symbolize_keys
                            else
                              {}
                            end
  end

  # # def software_definition
    # # @software_definition ||= (
      # # return nil if (gallery_url.blank? || gallery_software_id.blank?)
      # # blueprint_uri = URI(gallery_url + "/" +  gallery_software_id)
      # # return nil if (blueprint_uri.host.nil? || blueprint_uri.port.nil?)
      # # Net::HTTP.start(blueprint_uri.host, blueprint_uri.port) do |http|
        # # blueprint_request = Net::HTTP::Get.new blueprint_uri
        # # blueprint_response = http.request blueprint_request
        # # if blueprint_response.code.to_i >= 200 && blueprint_response.code.to_i < 400
          # # JSON.parse(blueprint_response.body).symbolize_keys
        # # else
          # # nil
        # # end    
      # # end )
  # # end
# 
  def default_http_protocol
    blueprint_protocol = blueprint_software[:http_protocol].to_s.gsub('_', ' ').upcase.gsub('ONLY', 'only').gsub('AND', 'and')
    ['HTTPS only', 'HTTP only', 'HTTPS and HTTP'].include?(blueprint_protocol) ? blueprint_protocol : 'HTTPS and HTTP'
  end

  def mandatory_fields_present?
    application.variables.map{|v| v.mandatory }.any?
  end

  def load_new_application_params
    {
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
    @existing_engine_names ||= engines_api.list_apps + engines_api.list_services
  end
  
  def existing_host_names
    @existing_host_names ||= Service.new(container_name: 'nginx').consumers.map{ |consumer| consumer[:variables][:fqdn].split('.').first }
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
    valid? && build_engine
  end
  
  def build_engine
    Thread.new do
      result = engines_api.build_engine engine_build_params
      
p :________________________build_done_____now_create_application
p result
p result.class
      
      create_fresh_application
    end
  end

  def create_fresh_application
    fresh_application = Application.where(container_name: application.container_name).first_or_create
    fresh_application.assign_attributes(application_display_properties_attributes: { gallery_icon_url: gallery_icon_url })
    fresh_application.application_display_properties.set_defaults
    fresh_application.save
  end

  def engine_build_params
    @engine_build_params ||= {
      software_name: default_name,
      engine_name: application.container_name,
      host_name: application.application_network_properties.host_name,
      domain_name: application.application_network_properties.domain_name,
      http_protocol: application.application_network_properties.http_protocol,
      memory: application.application_resources_properties.memory,
      variables: engine_build_variables_params,
      attached_services: engine_build_attached_services_params,
      repository_url: resolved_repository_url
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
          result[:service_handle] = (active_service[1] || active_service[0]) 
        end
      end
    end
  end

end

