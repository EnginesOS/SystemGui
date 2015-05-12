class DockerHubInstaller #< ActiveRecord::Base

  include ActiveModel::Model
  include ActiveModel::Validations


class Empty
  def count; 0; end
end
def self.columns; []; end
def self.all; Empty.new; end
  
  
  
  # belongs_to :application
  # has_one :attached_services_handler, through: :software
  # has_many :attached_services, through: :attached_services_handler
  # has_many :variables, as: :variable_consumer, dependent: :destroy

  # accepts_nested_attributes_for :variables, :allow_destroy => true
  
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
    )

  validate :docker_image_validation

  def self.new_software
    Software.new do |software|
      software.build_docker_hub_install
      software.build_network
      software.build_resource
      software.build_attached_services_handler

      software.docker_hub_install.type = "Software"
      software.network.http_protocol = "HTTPS and HTTP"
    end
  end
  
private

  def docker_image_validation
    if docker_image.blank?
      errors.add(:docker_image, ["Docker image source", "is required"])
    end
  end

  
end