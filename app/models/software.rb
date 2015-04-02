class Software < ActiveRecord::Base

 attr_accessor :remove_all_application_data

  has_one :software_variables_handler, dependent: :destroy
  has_one :attached_services_handler, dependent: :destroy
  has_one :backup_tasks_handler, dependent: :destroy
  has_one :display, dependent: :destroy
  has_one :network, dependent: :destroy
  has_one :resource, dependent: :destroy
  has_one :install, dependent: :destroy
  has_one :docker_hub_install, dependent: :destroy
  has_many :eports
  accepts_nested_attributes_for :software_variables_handler
  accepts_nested_attributes_for :attached_services_handler
  accepts_nested_attributes_for :backup_tasks_handler
  accepts_nested_attributes_for :display
  accepts_nested_attributes_for :network
  accepts_nested_attributes_for :resource
  accepts_nested_attributes_for :install
  accepts_nested_attributes_for :docker_hub_install
  accepts_nested_attributes_for :eports

  validates :engine_name, presence: true, uniqueness: true, length: { maximum: 16 }

 def self.user_visible_applications
    all.select { |software| (
      EnginesSoftware.default_startup_state(software.engine_name) == 'running' ||
      EnginesSoftware.is_active(software.engine_name) )
    }
  end
  
  def engine_build_params
    {
      engine_name: engine_name,
      host_name: network.host_name,
      domain_name: network.domain_name,
      http_protocol: network.http_protocol,
      memory: resource.memory,
      variables: engine_build_variables_params,
      attached_services: engine_build_attached_services_params,
      repository_url: install.repository_url,
      title: display.display_name
    }
  end

private
  
  def engine_build_variables_params
    return nil if software_variables_handler.nil?
    result = {}
    software_variables_handler.variables.each do |variable|
      result[variable.name] = variable.value
    end
    result
  end

  def engine_build_attached_services_params
    return [] if attached_services_handler.nil?
    attached_services_handler.attached_services.map do |attached_service|
      result = 
        {
          publisher_namespace: attached_service.publisher_namespace,
          type_path: attached_service.type_path
        }
      if attached_service.create_type.to_sym == :new
        result[:create_type] = "new"
      elsif attached_service.create_type.to_sym == :active
        result[:create_type] = "active"
        result[:service_handle] = attached_service.service_handle
      elsif attached_service.create_type.to_sym == :orphaned
        result[:create_type] = "orphaned"
        result[:parent_engine_name] = attached_service.parent_engine_name
      end
      result
    end
  end


end