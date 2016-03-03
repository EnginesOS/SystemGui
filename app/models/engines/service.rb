module Engines::Service

  include Engines::Api

  def system_service_object
    @system_service_object ||= load_container_api_call.is_a?(EnginesOSapiResult) ? nil : load_container_api_call
  end

  def load_container_api_call
    @load_container_api_call ||= engines_api.getManagedService(container_name)
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

  # def state_indicator
    # if is_error?
      # 'error'
    # else
      # if state.to_s == "nocontainer"
        # "disabled"
      # else
        # state
      # end
    # end
  # end

    # if service_state.kind_of?(EnginesOSapiResult)
      # service_state = "state_error"
    # end
    # indicator_class = "indicator_" + service.state_indicator.to_s
    # background_class = "engine_" + service.state_indicator.to_s

  def state
    return {state: :error, label:  'Cannot load - Error'} if system_service_object.blank?
    return {state: :error, label: service_container_state[:label] + ' - Error', detail: status_detail} if is_error?
    return task_at_hand_state if task_at_hand_state.present?
    service_container_state
  end

  def task_at_hand_state
    current_task_state = system_service_object.task_at_hand
    {label: current_task_state, state: :working, task_at_hand: current_task_state} if current_task_state.present?
  end

  #   def task_at_hand_state
  #   if current_task_state.present?
  #     case current_task_state
  #       when :s      actionators_from_api.map{ |actionator|top
  #         {label: 'Stopping'}
  #       when :start
  #         {label: 'Starting'}
  #       when :pause
  #         {label: 'Pausing'}
  #       when :unpause
  #         {label: 'Unpausing'}
  #       else
  #         {label: "#{current_task_state.to_s}-ing"}
  #     end.merge({state: :working, task_at_hand: current_task_state})
  #   end
  # end

  def service_container_state
    service_state = system_service_object.read_state
    if service_state == 'nocontainer'
      {state: :nocontainer, label: 'Unbuilt', detail: status_detail}
    else
      {state: service_state.to_sym, label: service_state.to_s.humanize, detail: status_detail}
    end
  end

  def status_detail
    return 'Rebuild required' if rebuild_required?
    return 'Restart required' if restart_required?
    return last_error if is_error?
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

  def restart_required?
    system_service_object.blank? ? false : system_service_object.restart_required?
  end

  def rebuild_required?
    system_service_object.blank? ? false : system_service_object.rebuild_required?
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

  def configurator_params_with_unpopulated_values
    @configurator_params_with_unpopulated_values ||= configurators_from_service_definition.map{ |c| c[:variables_attributes] = c[:params].values ; c }.map{ |c| c.delete :params ; c }
  end

  def configurator_params
    @configurator_params ||= configurator_params_with_unpopulated_values.map do |c|
      variables_values = service_configuration_variables_for(c[:name])
      c[:variables_attributes].compact.each do |v|
        variable_name = v[:name].to_sym
        v[:value] = variables_values.present? ? variables_values[variable_name] : nil
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



  def actionators_from_api
    result = engines_api.list_actionators system_service_object
    (result.is_a?(EnginesOSapiResult) ? [] : result.values) || []
  end


  # def is_actionable?
  #   actionators_from_service_definition.present?
  # end

  def actionator_params_with_unpopulated_values
    @actionator_params_with_unpopulated_values ||=
      actionators_from_api.map{ |actionator|
         actionator[:variables_attributes] = actionator[:params].present? ? actionator[:params].values : []
         actionator.delete :params
         actionator
       }
  end

  # def actionator_params
  #   @actionator_params ||= actionator_params_with_unpopulated_values.map do |actionator|
  #     variables_values = service_action_variables_for(actionator[:name])
  #     actionator[:variables_attributes].compact.each do |v|
  #       variable_name = v[:name].to_sym
  #       v[:value] = variables_values.present? ? variables_values[variable_name] : nil
  #     end
  #     actionator
  #   end
  # end

  # def actionators_from_service_definition
  #   @actionators_from_service_definition ||= ( ( service_definition[:actionators] || {} ).values || [] )
  # end

  def actionator_params_for(actionator_name)
    actionator_params_with_unpopulated_values.find{|c| c[:name] == actionator_name }.tap do |actionator|
      actionator[:variables_attributes].compact.each do |variable|
        v[:value] = resolve_templated_value v[:value]
      end
    end
  end

  def resolve_templated_value(unresolved_value)
    engines_api.get_resolved_service_string(unresolved_value, system_service_object)
  end

  def stop_container
    engines_api.stopService container_name
  end

  def start_container
    engines_api.startService container_name
  end

  def pause_container
    engines_api.pauseService container_name
  end

  def unpause_container
    engines_api.unpauseService container_name
  end

  def create_container
    engines_api.createService container_name
  end

  def recreate_container
    engines_api.recreateService container_name
  end

end
