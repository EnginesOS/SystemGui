class ApplicationServiceConnectionAvailableSubservice

  include Engines::Api

  attr_reader :application_service_connection, :type_path, :publisher_namespace
  
  def initialize(application_service_connection, new_subservice_definition)
    @application_service_connection = application_service_connection
    @title = new_subservice_definition[:title]
    @description = new_subservice_definition[:description]
    @type_path = new_subservice_definition[:type_path]
    @publisher_namespace = new_subservice_definition[:publisher_namespace]
    @service_container_name = new_subservice_definition[:service_container]
  end

  def new_subservice_connection_params
    { :type_path => @type_path, :publisher_namespace => @publisher_namespace }
  end
  
  def title_data
    @title_data ||= Engines::Services.titles_data[@service_container_name.to_sym]
  end

  def fa_icon
    title_data[:fa_icon]
  end
  
  def title
    @title + ' - ' + title_data[:title]
  end
  
end