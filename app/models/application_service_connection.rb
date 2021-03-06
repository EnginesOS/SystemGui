class ApplicationServiceConnection

  include Engines::Api

  def initialize(application_service)
    @application_service = application_service
  end

  def connection_params
    @connection_params ||=
      if @application_service.connection_params.is_a? Hash
        @application_service.connection_params
      else
        JSON.parse @application_service.connection_params
      end.symbolize_keys
  end

  def type_path
    connection_params[:type_path]
  end

  def publisher_namespace
    connection_params[:publisher_namespace]
  end

#service_detail

  def service_detail
    @service_detail ||= ApplicationServiceConnectionServiceDetail.new(type_path, publisher_namespace)
  end

  def variables_params_mutable_only
    variables_params.reject{|variable| variable[:immutable] == true}
  end


#connection detail

  def variables_values
    @variables_values ||= api_service_hash[:variables]
  end

  def api_service_hash
    @api_service_hash ||= load_api_service_hash
  end

  def load_api_service_hash
    service_hash = engines_api.retrieve_service_hash(connection_params)
    if service_hash.is_a? Hash
      service_hash.symbolize_keys
    else
      {}
    end
  end

  def build
    load_variables
  end

  def build_edit
    load_mutable_variables
  end

  def available_subservices
    @available_subservices ||= engines_api.load_avail_services_for_type(type_path).map do |available_subservice_definition|
      ApplicationServiceConnectionAvailableSubservice.new(self, available_subservice_definition)
    end
  end

  def existing_subservices
    []
  end

  def load_variables
    @application_service.variables.build(variables_params)
  end

  def load_mutable_variables
    @application_service.variables.build(variables_params_mutable_only)
  end

  def variables_params
    @variables_params ||= service_detail.variables_params_without_values.map do |variable_params|
      variable_params[:value] = variables_values[variable_params[:name].to_sym]
      variable_params
    end
  end

  def update
    result = engines_api.update_attached_service(update_params)
    if !result.was_success
      @application_service.engines_api_error = "Unable to update connected service. " +
                            (result.result_mesg.present? ? result.result_mesg[0..500] :
                                        "No result message given by engines api.")
    end
    result.was_success
  end

  def destroy
    result = engines_api.dettach_service(connection_params)
    if !result.was_success
      @application_service.engines_api_error = "Unable to remove connected service. " +
                            (result.result_mesg.present? ? result.result_mesg[0..500] :
                                        "No result message given by engines api.")
    end
    result.was_success
  end

  def perform_action
    action = @application_service.service_action.to_sym
    if action == :register
      api_method = :register_attached_service
    elsif action == :deregister
      api_method = :deregister_attached_service
    elsif action == :reregister
      api_method = :reregister_attached_service
    end
    result = engines_api.send(api_method, connection_params)
    if !result.was_success
      @application_service.engines_api_error = "Unable to #{action} connected service. " +
                            (result.result_mesg.present? ? result.result_mesg[0..500] :
                                        "No result message given by engines api.")
    end
    result.was_success
    # false
  end

  def update_params
    connection_params.merge(variables: variable_values_for_update_params)
  end

  def variable_values_for_update_params
    {}.tap do |result|
      @application_service.variables.each do |variable|
        value = variable.value
        if (variable.field_type.to_sym == :boolean || variable.field_type.to_sym == :checkbox)
          value = true if value == "1"
          value = false if value == "0"
        end
        result[variable.name.to_sym] = value
      end
    end
  end

end
