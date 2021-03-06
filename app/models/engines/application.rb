module Engines::Application

  include Engines::Api

  def container
    @container ||= load_container_api_call.is_a?(EnginesOSapiResult) ? nil : load_container_api_call
  end

  def load_container_api_call
    @load_container_api_call ||= engines_api.loadManagedEngine(container_name)
  end

  def blueprint_software_details
    blueprint['software'] || {}
  end

  def blueprint_software_name
      blueprint_software_details['name']
  end

  def services_properties
    @services_properties = attached_services_hash
  end

  def state
    return {state: :error, label: 'Cannot load - Error'} if container.blank?
    return error_state if is_error?
    return task_at_hand_state if task_at_hand_state.present?
    application_container_state
  end

  def error_state
    {state: :error, label: "#{application_container_state[:label]} - Error", detail: status_detail}
  end

  def task_at_hand_state
    current_task_state = container.task_at_hand
    {label: current_task_state, state: :working, task_at_hand: current_task_state} if current_task_state.present?
  end

  def application_container_state
    application_state = container.read_state
    if application_state == 'nocontainer'
      {state: :nocontainer, label: 'Unbuilt'}
    else
      {state: application_state.to_sym, label: application_state.to_s.humanize, detail: status_detail}
    end
  end

  def status_detail
    return 'Reinstall required' if reinstall_required?
    return 'Restart required' if restart_required?
    # return last_error if is_error?
    err = last_error if is_error?
    err
  end

  def primary_web_site
    if web_sites.present?
      web_sites.first
    else
      nil
    end
  end

  def get_first_run_web_site
    result = engines_api.get_resolved_engine_string(blueprint_software_details['first_run_url'], container)
    result if result.is_a? String
  end

  def first_run_web_site
    @first_run_web_site ||= get_first_run_web_site || primary_web_site
  end

  {
    active?: 'is_active?',
    is_running: 'is_running?',
    reinstall_required?: 'rebuild_required?',
    restart_required?: 'restart_required?',
    is_error?: 'is_error?',
    has_container?: 'has_container?',
    container_type: 'ctype',
    host_name: 'hostname',
    http_protocol: 'http_protocol',
    http_protocol_as_sym: 'protocol',
    https_only: 'https_only',
    domain_name: 'domain_name',
    web_sites: 'web_sites',
    default_startup_state: 'setState',
    memory: 'memory',
    monitored: 'monitored',
    framework: 'framework',
    runtime: 'runtime',
    image: 'image',
    repository: 'repository',
    port: 'web_port',
    external_ports: 'eports',
    last_error: 'last_error',
    last_result: 'last_result',
    stats: 'stats',
    ps_container: 'ps_container',
    logs_container: 'logs_container',
    environments: 'environments',
    volumes_hash: 'volumes',
    consumers_hash: 'consumers',
    deployment_type: 'deployment_type'
  }.
  each do |method, instruction|
    define_method(method) do
      container.send(instruction) if container.present?
    end
  end

  def blueprint
    @blueprint ||= engines_api.get_engine_blueprint(container_name).tap{|result| result = {} if result.is_a? EnginesOSapiResult}
  end

  def network_metrics
    engines_api.get_container_network_metrics(container_name).tap{|result| result = {} if result.is_a? EnginesOSapiResult}
  end

  def memory_statistics
    engines_api.get_engine_memory_statistics(container_name).tap{|result| result = {} if result.is_a? EnginesOSapiResult}
  end

  def installation_report
    engines_api.get_engine_build_report(container_name).tap{|result| result = '' if result.is_a? EnginesOSapiResult}
  end

  def attached_services_hash
    @attached_services_hash = engines_api.list_attached_services_for('ManagedEngine', container_name)
  end

   def available_services_hash
    @available_services_hash = engines_api.list_avail_services_for container
  end

  def available_services
    available_services_hash[:services]
  end

  {
    stop_container: 'stopEngine',
    start_container: 'startEngine',
    pause_container: 'pauseEngine',
    unpause_container: 'unpauseEngine',
    destroy_container: 'destroyEngine',
    reinstall: 'reinstall_engine',
    restart_container: 'restartEngine',
    create_container: 'createEngine',
    recreate_container: 'recreateEngine'
  }.
  each do |method, instruction|
    define_method(method) do |options={}|
      if options.present?
        engines_api.send(instruction, container_name, options )
      else
        engines_api.send(instruction, container_name )
      end
    end
  end


  def actionators_from_api
    result = engines_api.list_actionators container
    (result.is_a?(EnginesOSapiResult) ? [] : result.values) || []
  end

  # def is_actionable?
  #   actionators_from_application_definition.present?
  # end

  def actionator_params_with_unpopulated_values
    @actionator_params_with_unpopulated_values ||=
      actionators_from_api.map{ |actionator|
         actionator[:variables_attributes] = actionator[:params].present? ? actionator[:params].values : []
         actionator.delete :params
         actionator
       }
  end

  def actionator_params_for(actionator_name)
    actionator_params_with_unpopulated_values.find{|c| c[:name] == actionator_name }.tap do |actionator|
      actionator[:variables_attributes].compact.each do |variable|
        variable[:value] = resolve_templated_value variable[:value]
      end
    end
  end

  def resolve_templated_value(unresolved_value)
    engines_api.get_resolved_engine_string(unresolved_value, container)
  end


end
