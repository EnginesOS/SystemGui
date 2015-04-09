module EnginesServiceInstructor

  {
    engines_service: 'getManagedService',
    stop: 'stopService',
    start: 'startService',
    pause: 'pauseService',
    unpause: 'unpauseService',
    create_container: 'createService',
    recreate: 'recreateService',
    network_metrics: 'get_container_network_metrics',
    memory_statistics: 'get_service_memory_statistics'
  }.
  each do |method, instruction|
    define_method(method) { |service_name| engines_api.send(instruction, service_name) }
  end

end