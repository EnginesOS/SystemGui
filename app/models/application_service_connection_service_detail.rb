class ApplicationServiceConnectionServiceDetail

  include Engines::Api

  def initialize(type_path, publisher_namespace)
    @type_path = type_path
    @publisher_namespace = publisher_namespace
  end

  def service_detail
    
p :publisher_namespace
p @publisher_namespace
p @type_path
p :type_path   
    @service_detail ||= engines_api.software_service_definition(
                                      publisher_namespace: @publisher_namespace,
                                      type_path: @type_path)
  end
  
  def variables_params_without_values
    service_detail[:consumer_params].values
  end

  def title
    service_detail[:title] || '?'
  end
  
  def description
    service_detail[:description] || '?'
  end
  
  def persistant
    service_detail[:persistant] || false
  end
  
  def immutable
    !mutable
  end
  
  def mutable
    service_detail[:immutable] != true
  end

  def connectable
    service_detail[:shareable] || false
  end

  def variables_params_mutable_only
    variables_params.reject{|variable| variable[:immutable] == true}
  end

end