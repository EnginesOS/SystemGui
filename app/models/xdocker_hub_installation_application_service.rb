DockerHubInstallationApplicationService

class DockerHubInstallationApplicationService # < ActiveRecord::Base

  include ActiveModel::Model
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

end