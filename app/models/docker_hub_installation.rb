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
    :new_attached_service_publisher_namespace,
    :new_attached_service_type_path,
    :new_environment_variable,
    :new_eport,
    :scroll_form_to,
    :advanced_selected )

  validate :docker_image_validation


  def self.load_new
    new do |new_docker_hub_installation|
      new_docker_hub_installation.type = "Software"
      new_docker_hub_installation.build_application do |new_application|
        new_application.build_resources_properties
        new_application.build_network_properties(http_protocol: "HTTPS and HTTP")
        new_application.application_services.build
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