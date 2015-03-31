class DockerHubInstall < ActiveRecord::Base
  
  belongs_to :software
  has_one :attached_services_handler, through: :software
  has_many :attached_services, through: :attached_services_handler
  has_many :variables, through: :attached_services

  # accepts_nested_attributes_for :software, :attached_services, :variables
  
  attr_accessor(
    :memory,
    :docker_image,
    :type,
    :host_name,
    :web_port,
    :user_id,
    :self_start,
    :run_command,
    :new_attached_service_publisher_namespace,
    :new_attached_service_type_path,
    :new_eport,
    :scroll_form_to,
    )

  def self.new_software
    Software.new do |software|
      software.build_docker_hub_install
      software.build_display
      software.build_resource
      software.build_attached_services_handler
    end
  end
  
end