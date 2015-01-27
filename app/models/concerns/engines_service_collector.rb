module EnginesServiceCollector

  extend EnginesApi

  def all_service_names
    engines_api.list_services
  end

end