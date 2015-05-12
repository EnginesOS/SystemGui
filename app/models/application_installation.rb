class ApplicationInstallation < ActiveRecord::Base

  require 'json'
  include Engines::Api

  attr_accessor(
    :gallery_url,
    :gallery_software_id,
    :license_terms_and_conditions,
    :advanced_installation
    )
    
  has_one :application
  accepts_nested_attributes_for :application

  validate :license_terms_and_conditions_accepted_validation

  def load
    build_application(load_application_params)
    self
  end
  
  def create
    valid? && create_application
  end

  # def create_application
    # engines_api.build_engine(engine_build_params)
  # end

  def installing_params
    {
      gallery_url: gallery_url,
      gallery_software_id: gallery_software_id,
      title: title,
      application_name: application.container_name,
      host_name: application.network_properties.host_name,
      domain_name: application.network_properties.domain_name
      }
  end

  def icon_url
    software_definition[:icon_url_from_gallery] || software_definition[:icon_url_from_blueprint]
  end

  def description
    software_definition[:detail]
  end

  def title
    software_definition[:title]
  end

  def license_label
    blueprint_software[:license_label] || blueprint_software[:license_name]
  end

  def license_sourceurl
    blueprint_software[:license_sourceurl]
  end
  
  def repository_url
    software_definition[:repository_url]
  end
  
  def browser_target
    license_label.underscore
  end
  
  def default_name
    blueprint_software[:name]
  end


  def blueprint
    JSON.parse(software_definition[:blueprint]).symbolize_keys
  end
  
  def blueprint_software
    blueprint[:software].symbolize_keys
  end

  def software_definition
    @software_definition ||= (
      return nil if (gallery_url.blank? || gallery_software_id.blank?)
      blueprint_uri = URI(gallery_url + "/" +  gallery_software_id)
      return nil if (blueprint_uri.host.nil? || blueprint_uri.port.nil?)
      Net::HTTP.start(blueprint_uri.host, blueprint_uri.port) do |http|
        blueprint_request = Net::HTTP::Get.new blueprint_uri
        blueprint_response = http.request blueprint_request
        if blueprint_response.code.to_i >= 200 && blueprint_response.code.to_i < 400
          JSON.parse(blueprint_response.body).symbolize_keys
        else
          nil
        end    
      end )
  end

  def default_http_protocol
    blueprint_protocol = blueprint_software[:http_protocol]
    ['HTTPS only', 'HTTP only', 'HTTPS and HTTP'].include?(blueprint_protocol) ? blueprint_protocol : 'HTTPS and HTTP'
  end


  def load_application_params
    {
      container_name: unique_application_name,

      variables_attributes: blueprint_software[:variables],
      network_properties_attributes: {
        host_name: unique_host_name,
        domain_name: DomainSettings.engines_default_domain,
        http_protocol: default_http_protocol
      },
      resources_properties_attributes: {
        required_memory: blueprint_software[:required_memory],
        memory: blueprint_software[:recommended_memory] || blueprint_software[:required_memory]
      },
      application_services_attributes: load_application_services_params
    }

  end

  def load_application_services_params
    blueprint_software[:service_configurations].map do |service_configuration|
      service_configuration.symbolize_keys!
      params =  {
                  publisher_namespace: service_configuration[:publisher_namespace],
                  type_path: service_configuration[:type_path]
                }
      if ApplicationService.new(params).persistant
        params        
      end.compact
    end
  end



  def license_terms_and_conditions_accepted_validation
    if license_terms_and_conditions != "1"
      errors.add(:license_terms_and_conditions, ["License", "must be accepted"])
    end
  end

  def unique_host_name
    default_host_name = default_name.gsub('-', '')
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
      engines_api.build_engine engine_build_params
    end
  end

  def engine_build_params
    {
      engine_name: application.container_name,
      host_name: application.network_properties.host_name,
      domain_name: application.network_properties.domain_name,
      http_protocol: application.network_properties.http_protocol,
      memory: application.resources_properties.memory,
      variables: engine_build_variables_params,
      attached_services: engine_build_attached_services_params,
      repository_url: repository_url
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
      result = 
        {
          publisher_namespace: application_service.publisher_namespace,
          type_path: application_service.type_path
        }
      if application_service.create_type.blank? || application_service.create_type.to_sym == :new
        result[:create_type] = "new"
      elsif application_service.create_type.to_sym == :active
        result[:create_type] = "active"
        result[:service_handle] = application_service.service_handle
        result[:parent_engine] = application_service.parent_engine
      elsif application_service.create_type.to_sym == :orphaned
        result[:create_type] = "orphaned"
        result[:service_handle] = application_service.service_handle
        result[:parent_engine] = application_service.parent_engine
      end
      result
    end
  end


# 
  # include ActionController::Live
# 
  # def progress
    # error = false
    # previous_line = ''
    # response.headers['Content-Type'] = 'text/event-stream'
    # send_event :installation_progress, "Starting build...\n"
    # File.open('/home/engines/deployment/deployed/build.out') do |f|
      # f.extend(File::Tail)
      # f.interval = 10
      # f.backward(10000)
      # f.tail do |line|
        # send_event :installation_progress, line
        # if line.start_with?("Build Finished")
          # error = true if previous_line.start_with?("ERROR")
          # break 
        # end
        # previous_line = line
      # end
    # end
    # unless error
      # EnginesInstaller.installation_report_lines(params[:engine_name]).each do |line|
        # send_event :installation_report, line
      # end
    # end
  # ensure
    # send_event :message, "close"
    # response.stream.close
  # end
# 
# # private
# 
  # def send_event(event, data='')
       # response.stream.write "event: #{event}\n"
       # response.stream.write "data: #{data}\n\n"
  # end








end


  # extend EnginesApi
# 
  # def self.build_engine (engine_build_params)
    # engines_api.build_engine engine_build_params
  # end
#   
  # def self.build_engine_from_docker_image (engine_build_params)
    # engines_api.build_engine_from_docker_image engine_build_params
  # end
# 
  # def self.generate_next_unique_engine_name_for(engine_name)
    # existing_engine_names = EnginesSoftware.all_engine_names
    # unique_engine_name_candidate = engine_name
    # index = 2
    # while existing_engine_names.include? unique_engine_name_candidate do
      # unique_engine_name_candidate = engine_name + index.to_s
      # index += 1
    # end
    # unique_engine_name_candidate
  # end
# 
  # def self.generate_next_unique_host_name_for(host_name)
    # host_name = host_name.sub('-', '')
    # existing_host_names = EnginesSoftware.all_host_names
    # unique_host_name_candidate = host_name
    # index = 2
    # while existing_host_names.include? unique_host_name_candidate do
      # unique_host_name_candidate = host_name + index.to_s
      # index += 1
    # end
    # unique_host_name_candidate
  # end
# 
  # def self.engine_name_is_unique?(engine_name)
    # EnginesSoftware.all_engine_names.exclude?(engine_name)
  # end
# 
  # def self.fqdn_is_unique?(fqdn)
    # EnginesSoftware.all_fqdns.exclude?(fqdn)
  # end
#   
  # def self.installation_report_lines(engine_name)
    # engines_api.get_engine_build_report(engine_name).split("\n")
  # end
#   
  
  
  
  



  # def initialize(gallery_url, gallery_software_id)
    # @gallery_url = gallery_url,
    # @gallery_software_id = gallery_software_id
  # end


  # def software
    # new_software_params = new_software_from_gallery_params(gallery_url: gallery_url, gallery_software_id: gallery_software_id)
    # if new_software_params.nil?
      # nil
    # else
      # Software.new(new_software_params) do |software|
        # software.attached_services_handler.load_attached_services_details
      # end
    # end
  # end
# 
  # def self.new_software_for_create(new_software_install_params)
    # Software.new(new_software_install_params) do |software|
      # software.install.load_blueprint
      # software.attached_services_handler.load_attached_services_details
    # end
  # end
# 
  # def load_blueprint
    # @blueprint ||= (EnginesRepository.blueprint_from_repository repository_url: repository_url).to_json.to_s
  # end
# 
# private
# 
#  
  # def new_software_from_gallery_params(gallery_software_params)
    # gallery_software = Engines::Galleries::software(gallery_software_params)
# 
    # if gallery_software.kind_of?(EnginesOSapiResult) || gallery_software.nil?
      # nil
    # else
#   
      # repository_url = gallery_software[:repository_url]
      # blueprint = EnginesRepository.blueprint_from_repository repository_url: repository_url
# 
      # blueprint_software_params = blueprint[:software]
      # software_name = blueprint_software_params['name'].gsub(/[^0-9A-Za-z]/, '').downcase
#   
      # icon_url = 
        # (gallery_software[:icon_url_from_gallery] if gallery_software[:icon_url_from_gallery].present?) ||
        # (gallery_software[:icon_url_from_blueprint] if gallery_software[:icon_url_from_blueprint].present?) ||
        # (gallery_software[:icon_url_from_repository] if gallery_software[:icon_url_from_repository].present?) ||
        # "_placeholder_for_missing_engine.jpg"
#   
      # {
        # engine_name: EnginesInstaller.generate_next_unique_engine_name_for(software_name),
        # install_attributes: {
          # repository_url: repository_url,
          # gallery_url: gallery_software_params[:gallery_url],
          # gallery_software_id: gallery_software_params[:gallery_software_id],
          # default_image_url: icon_url,
          # license_name: blueprint_software_params['license_name'],
          # license_label: blueprint_software_params['license_label'],
          # license_sourceurl: blueprint_software_params['license_sourceurl'],
          # license_terms_and_conditions: false,
          # blueprint: blueprint.to_json.to_s
        # },
        # display_attributes: {
          # display_name: blueprint_software_params['short_title'],
          # display_description: blueprint_software_params['description']
        # },
        # software_variables_handler_attributes: {variables_attributes: blueprint_software_params["variables"]},
        # network_attributes: {
          # host_name: EnginesInstaller.generate_next_unique_host_name_for(software_name),
          # domain_name: Network.best_default_domain,
          # http_protocol: Network.best_http_protocol(blueprint_software_params['http_protocol'])
        # },
        # resource_attributes: {
          # required_memory: blueprint_software_params['required_memory'],
          # memory: blueprint_software_params['recommended_memory'] || blueprint_software_params['requiredmemory']
        # },
        # attached_services_handler_attributes: {attached_services_attributes:
          # blueprint_software_params["service_configurations"].map do |attached_service|
            # if EnginesAttachedService.service_is_persistant(attached_service["type_path"], attached_service["publisher_namespace"])
              # {
                # publisher_namespace: attached_service["publisher_namespace"],
                # type_path: attached_service["type_path"],
                # create_type: :new
              # }
            # end
          # end.compact
        # }
      # }
# 
    # end
# 
  # end

