class Service < ActiveRecord::Base

  include Engines::Service
  extend Engines::Api

  def self.load_all
    service_container_names_list.map do |container_name|
      load_by_container_name(container_name)
    end
  end

  def self.load_by_container_name(container_name)
    service = where(container_name: container_name).first_or_create
    service.save
    service
  end

  def self.service_container_names_list
    engines_api.list_services.sort
  end

  def self.services_tree_by_provider
    engines_api.managed_service_tree
  end

  def self.services_tree_by_engine
    engines_api.get_managed_engine_tree
  end

  def self.services_tree_of_orphaned_services
    engines_api.get_orphaned_services_tree
  end

  def self.services_tree_by_configurations
    engines_api.get_configurations_tree
  end

  def build_configuration_for configurator_name
    ServiceConfiguration.new(service: self, name: configurator_name).load
  end

  def build_action_for actionator_name
    ServiceAction.new(service: self, name: actionator_name).load
  end



  #
  # def build_service_action_for actionator_name
  #   @service_action = ServiceAction.new(service: self)
  #   @service_action.assign_attributes(actionator_params_for actionator_name)
  #   @service_action
  # end




end
