class DockerHubInstallation < ActiveRecord::Base

  # include ActiveModel::Model
  # include ActiveModel::Validations
  include Engines::Api

# class Empty
  # def count; 0; end
# end
# def self.columns; []; end
# def self.all; Empty.new; end
  
  
  
  has_one :application
  # has_one :attached_services_handler, through: :software
  # has_many :attached_services, through: :attached_services_handler
  # has_many :variables, as: :variable_consumer, dependent: :destroy

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
    :scroll_form_to,
    :advanced_selected )

  validate :docker_image_validation


  def self.load_new
    new do |new_docker_hub_installation|
      new_docker_hub_installation.type = "Software"
      new_docker_hub_installation.build_application do |new_application|
        new_application.build_application_resources_properties
        new_application.build_application_network_properties(http_protocol: "HTTPS and HTTP")
      end
    end
  end

  def ready_to_install?
    !load_new_form_elements && valid?
  end

  def load_new_form_elements
    if new_application_service_publisher_namespace.present? && new_application_service_type_path.present?
      application.application_services.
        build(create_type: :new, publisher_namespace: new_application_service_publisher_namespace, type_path: new_application_service_type_path).
        load_variable_definitions
      self.new_application_service_type_path = nil
      self.new_application_service_publisher_namespace = nil
      self.scroll_form_to = :application_service_fields
      true
    elsif new_environment_variable.present?
      application.variables.build
      self.scroll_form_to = :environment_variable_fields
      self.new_environment_variable = nil
      true
    elsif new_eport.present?
      application.eports.build
      self.scroll_form_to = :eport_fields
      self.new_eport = nil
      true
    else
      self.scroll_form_to = nil
      false
    end
  end


  def installation_params
    {
      engine_name: application.container_name,
      memory: application.application_resources_properties.memory,
      docker_image: docker_image,
      run_as_user: run_as_user,
      run_command: run_command,
      variables: variables_installation_params,
      attached_services: services_installation_params,
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
     application.application_services.map do |service|
       {}.tap do |result|
         type = service.create_type.to_sym
         result[:create_type] = type.to_s
         result[:publisher_namespace] = service.publisher_namespace
         result[:type_path] = service.type_path
         case type
         when :new
           result[:variables] = service.variables_params
         when :active
           active_service = service.active_service.split(" - ")
           result[:parent_engine] = active_service[0]
           result[:service_handle] = active_service[1] 
         when :orphan
           orphan_service = service.orphan_service.split(" - ")
           result[:parent_engine] = orphan_service[0]
           result[:service_handle] = orphan_service[1] 
         end
       end
     end
   end

   def eports_installation_params
     application.eports.map do |eport|
       {}.tap do |result|
         result[:name] = eport.name
         result[:internal_port] = eport.internal_port
         result[:external_port] = eport.external_port
         result[:tcp] = (eport.tcp == "1")
         result[:udp] = (eport.udp == "1")
       end
     end
   end
   
   


  # def load_new_application_params
    # {
      # container_name: "",
      # },
      # application_services_attributes: load_application_services_params
    # }
# 
  # end



  # def self.new_installation
    # new.application do |new_application|
      # # application.build_docker_hub_installation
      # new_application.build_network_properties http_protocol: "HTTPS and HTTP"
      # docker_hub_installation.application.build_resources_properties
      # # application.build_attached_services_handler
      # docker_hub_installation.type = "Software"
      # # docker_hub_installation.network.http_protocol = "HTTPS and HTTP"
    # end
  # end

  def available_services
    engines_api.load_avail_services_for_type 'ManagedEngine'
  end
  
private

  def docker_image_validation
    if docker_image.blank?
      errors.add(:docker_image, ["Docker image source", "is required"])
    end
  end

  
end