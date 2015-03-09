module EnginesServiceConsumerManager

  extend EnginesApi

  def service_providers_with_registered_consumers
    # engines_api.list_service_providers_in_use
    ['EnginesSystem', 'Joeblow Technology']
  end

  def services_with_registered_consumers_for_provider provider_name
    # engines_api.find_service_consumers { publisher_namespace: provider_name }
    [
      {service_type: 'dns', parent_engine: 'imap'},
      {service_type: 'dns', parent_engine: 'smtp'},
      {service_type: 'dns', parent_engine: 'db'}
    ]
  end

end