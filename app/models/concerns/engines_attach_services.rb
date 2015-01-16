module EnginesAttachServices

  extend EnginesApi

  def self.available_services_for object
    engines_api.list_avail_services_for object
  end

end