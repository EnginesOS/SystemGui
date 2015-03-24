module EnginesAttachedService

  extend EnginesApi

  def self.service_detail_for(type_path, publisher_namespace)
    
p 'service_detail_for' 
p publisher_namespace
p type_path
    
    engines_api.software_service_definition(
      publisher_namespace: publisher_namespace,
      type_path: type_path)
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