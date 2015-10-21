class ApplicationServiceConnectionSubserviceConnector

  include Engines::Api

  attr_reader :application_service_connection_params, :new_subservice_connection_params
  
  def initialize(application_service_connection_params, new_subservice_connection_params)
    @application_service_connection_params = application_service_connection_params
    @new_subservice_connection_params = new_subservice_connection_params
  end

  def connect_subservice_identification_params_json
    @new_subservice_connection_params.to_json
  end
  
  # def connect_subservice_params
# 
    # p "also trying to hashify..."
    # p @connect_subservice_params_json
    # p "also trying to hashify..."
#     
#     
    # JSON.parse(@connect_subservice_params_json).symbolize_keys
#         
#     
#     
  # end
  
#   
  def application_service_connection_identification_params_json
    @application_service_connection_params.to_json
  end

  def service_detail
    @service_detail ||= ApplicationServiceConnectionServiceDetail.new(type_path, publisher_namespace)
  end
  
  def title
    service_detail.title
  end
  
  def type_path
     @new_subservice_connection_params[:type_path]
  end
   
  def publisher_namespace
     a = @new_subservice_connection_params[:publisher_namespace]
     p :aaaaaaaa_pub
     p @new_subservice_connection_params
     p a
     a
  end
   
   
    # {}
    # @
    # @description = service_detail[:description]
    # @type_path = subservice_definition[:type_path]
    # @publisher_namespace = subservice_definition[:publisher_namespace]


  
end