module Engines::Service

  include Engines::Api
   

  
  def system_service_object
    @system_service_object ||= engines_api.getManagedService container_name
    @system_service_object = nil if @system_service_object.is_a? EnginesOSapiResult
    @system_service_object
  end

  def title_data
   Engines::Services.titles_data[container_name.to_sym]
  end

  def human_name
    title_data.present? ? title_data[:title] : 'missing'
  end

  def fa_icon
    title_data.present? ? title_data[:fa_icon] : 'circle'
  end
  
  def label
    "#{container_name} - #{human_name}"
  end

  def state_indicator
    if is_error?
      'error'
    else
      if state.to_s == "no_container"
        "disabled"
      else
        state
      end
    end
  end

  def state
    if system_service_object.blank?
      'no_service'
    else
      current_task_state = system_service_object.task_at_hand
      if current_task_state.present?
        current_task_state
      else      
        service_state = system_service_object.read_state
        if service_state == 'nocontainer'
          'no_container'
        else
          service_state
        end
      end
    end
  end

  def web_sites
    system_service_object.blank? ? [] : system_service_object.web_sites
  end

  def default_startup_state
    system_service_object.blank? ? '?' : system_service_object.setState
  end

  def memory
    system_service_object.blank? ? '?' : system_service_object.memory
  end

  def is_error?
    system_service_object.blank? ? true : system_service_object.is_error?
  end

  def framework
    system_service_object.blank? ? '?' : system_service_object.framework
  end

  def runtime
    system_service_object.blank? ? '?' : system_service_object.runtime
  end

  def image
    system_service_object.blank? ? '?' : system_service_object.image
  end

  def repository
    system_service_object.blank? ? '?' : system_service_object.repository
  end

  def port
    system_service_object.blank? ? '?' : system_service_object.web_port
  end

  def eports
    system_service_object.blank? ? [] : system_service_object.eports
  end

  def last_error
    system_service_object.blank? ? '?' : system_service_object.last_error
  end

  def last_result
    system_service_object.blank? ? '?' : system_service_object.last_result
  end

  def environments
    system_service_object.blank? ? nil : system_service_object.environments
  end

  def volumes
    system_service_object.blank? ? [] : system_service_object.volumes
  end

  def consumers
    system_service_object.blank? ? [] : system_service_object.registered_consumers
  end

  def stats
    system_service_object.blank? ? nil : system_service_object.stats
  end

  def ps_container
    system_service_object.blank? ? nil : system_service_object.ps_container
  end

  def logs_container
    system_service_object.blank? ? nil : system_service_object.logs_container
  end

  def network_metrics
    result = engines_api.get_container_network_metrics container_name
    return {} unless result.is_a? Hash
    result
  end

  def memory_statistics
    result = engines_api.get_service_memory_statistics container_name
    return {} unless result.is_a? Hash
    result
  end
  
  def type_path
    system_service_object.blank? ? nil : system_service_object.type_path
  end
  
  def publisher_namespace
    system_service_object.blank? ? nil : system_service_object.publisher_namespace
  end

  def service_definition
    @service_definition ||= ( engines_api.get_service_definition(type_path, publisher_namespace) || {} )
  end

  def is_configurable?
    configurators_from_service_definition.present?
  end

  def configurator_params_without_values
    @configurator_params_without_values ||= configurators_from_service_definition.map{ |c| c[:variables_attributes] = c[:params].values ; c }.map{ |c| c.delete :params ; c }
  end
  
  def configurator_params
    @configurator_params ||= configurator_params_without_values.map do |c|
      variables_values = service_configuration_variables_for(c[:name])
      c[:variables_attributes].compact.each do |v|
        v[:value] = variables_values[v[:name].to_sym]
      end
      c
    end
  end

  def configurators_from_service_definition
    @configurators_from_service_definition ||= ( ( service_definition[:configurators] || {} ).values || [] )
  end

  def configurator_params_for configurator_name
    configurator_params.find{|c| c[:name] == configurator_name }
  end
  
  def service_configuration_variables_for(configurator_name)
    result = engines_api.retrieve_service_configuration(service_name: container_name, configurator_name: configurator_name)
    (result.is_a?(EnginesOSapiResult) ? {} : result[:variables]) || {}
  end

  def stop
    engines_api.stopService container_name
  end

  def start
    engines_api.startService container_name
  end

  def pause
    engines_api.pauseService container_name
  end

  def unpause
    engines_api.unpauseService container_name
  end

  def create_container
    engines_api.createService container_name
  end

  def recreate
    engines_api.recreateService container_name
  end

end