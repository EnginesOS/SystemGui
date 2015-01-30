module EnginesAttachedService

  extend EnginesApi

  def self.service_detail(params)
    engines_api.software_service_definition(
      service_provider: params[:service_provider],
      service_type: params[:service_type])
    # {title: "Fake title", description: "Fake description about this thing."}
  end

  def self.attach_service params
    engines_api.attach_service params
  end

  def self.detach_service params
    engines_api.detach_service params
  end

  def self.attach_subservice params
    engines_api.attach_subservice params
  end
  
  def self.detach_subservice params
    engines_api.detach_subservice params
  end

end