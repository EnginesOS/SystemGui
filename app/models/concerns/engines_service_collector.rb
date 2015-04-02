module EnginesServiceCollector

  def all_service_names
    engines_api.list_services
  end

  def service_providers_with_registered_consumers
    engines_api.list_service_providers_in_use
  end

  def services_with_registered_consumers_for_provider provider_name
    engines_api.find_service_consumers({ publisher_namespace: provider_name })
  end

  def services_tree_by_provider
    engines_api.managed_service_tree
  end

  def services_tree_by_engine
    engines_api.get_managed_engine_tree
  end

  def services_tree_of_orphaned_services
    engines_api.get_orphaned_services_tree
  end

end