class ApplicationServiceConnectionSubserviceConnectorConfiguration < ActiveRecord::Base

  include Engines::Api

  attr_accessor :application_name, :application_service_connection_params, :type_path, :publisher_namespace, :engines_api_error

  has_many :variables, as: :variable_consumer, dependent: :destroy

  accepts_nested_attributes_for :variables
  
  def build_new_for(application_service_connection_subservice_connector_configuration_params)
    assign_attributes(application_service_connection_subservice_connector_configuration_params)
    load_variables_for_new
    self
  end

  def build_create_for(application_service_connection_subservice_connector_configuration_params)
    assign_attributes(application_service_connection_subservice_connector_configuration_params)
    deserialize_application_service_connection_params
    self
  end

  def connect
    valid? && connect_subservice
  end


  def subservice_connect_params
    {
      service_connection: application_service_connection_params,
      subservice_params: {
        type_path: type_path,
        publisher_namespace: publisher_namespace,
        variables: subservice_connect_variables_params
      }
    }
  end 

  def subservice_connect_variables_params
    variables.map{ |variable| variable.name_value_pair }.inject(:merge)
  end
  
  def connect_subservice
    @engines_api_error = ""
    result = engines_api.attach_subservice(subservice_connect_params)
    if !result.was_success
      @engines_api_error = "Unable to create attached subservice. " + 
        (result.result_mesg.present? ? result.result_mesg.to_s : "No result message given by engines api. Called 'attach_subservice' with params: #{subservice_connect_params}")
    end
    result.was_success
  end

  def deserialize_application_service_connection_params
    self.application_service_connection_params = JSON.parse(application_service_connection_params).symbolize_keys
  end

  def application_service_connection_service_name
    application_service_connection_params[:service_container_name]
  end

  def load_variables_for_new
    variables.build(templated_variables_params)
  end

  def templated_service_detail 
    @templated_service_detail ||= engines_api.templated_software_service_definition(
                                                parent_engine: application_service_connection_service_name,
                                                publisher_namespace: publisher_namespace,
                                                type_path: type_path)
  end
  
  def templated_variables_params
    templated_service_detail[:consumer_params].values  
  end
  
  def service_detail
    @service_detail ||= ApplicationServiceConnectionServiceDetail.new(@type_path, @publisher_namespace)
  end
  
  def title
    service_detail.title
  end
  
  def label
    title.to_s + ' to ' + application_service_connection_service_name.to_s + ' on ' + application_name.to_s
  end
  
end