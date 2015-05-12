class Service < ActiveRecord::Base

  include Engines::Service
  extend Engines::Api

  def self.load_all
    service_container_names_list.map do |container_name|
      where(container_name: container_name).new
    end
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

end
