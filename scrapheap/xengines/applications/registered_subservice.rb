module Engines::Applications

  class SubserviceRegistration

  include Engines::Api

  attr_accessor :type_path, :publisher_namespace, :persistant, :service_handle, :variables

  def initialize(service_registration)
    @service_registration = service_registration
  end

  def build(params)
    @type_path = params[:type_path]
    @publisher_namespace = params[:publisher_namespace]
    @variables = params[:variables]
    @persistant = params[:persistant]
    @service_handle = params[:service_handle]
    self
  end    

  def title
    service_detail[:title]
  end
  
  def description
    service_detail[:description]
  end

  def service_detail
    @service_detail ||= engines_api.software_service_definition(
                        publisher_namespace: @publisher_namespace,
                        type_path: @type_path)
  end

end
end
