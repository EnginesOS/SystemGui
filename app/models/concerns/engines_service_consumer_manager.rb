module EnginesServiceConsumerManager

  extend EnginesApi

  def self.service_providers_with_registered_consumers
    engines_api.list_service_providers_in_use
  end

  def self.services_with_registered_consumers_for_provider provider_name
    engines_api.find_service_consumers({ publisher_namespace: provider_name })
  end

  def self.services_tree_by_provider
    engines_api.managed_service_tree
  end

  def self.services_tree_by_engine
    engines_api.get_managed_engine_tree
  end

end