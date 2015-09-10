module Engines::Service

  include Engines::Api
   
#loaders
  
  def system_service_object
    @system_service_object ||= engines_api.getManagedService container_name
    @system_service_object = nil if @system_service_object.is_a? EnginesOSapiResult
  end

#extractors
  
  def human_name
    titles_data[container_name.to_sym].present? ? titles_data[container_name.to_sym][:title] : 'missing'
  end

  def fa_icon
    titles_data[container_name.to_sym].present? ? titles_data[container_name.to_sym][:fa_icon] : 'circle'
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
    if system_service_object.blank? || (system_service_object.read_state == 'nocontainer')
      'no_container'
    else
      result
    end
  end

#inspectors     

  # def fqdn
    # service_fqdn = system_service_object.fqdn
    # if service_fqdn.kind_of?(EnginesOSapiResult)
      # service_fqdn = "?"
    # end
    # service_fqdn   
  # end
  
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
    # system_service_object.blank? ? '?' : system_service_object.memory
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

  
  # def configurators
    # configurators_hash.keys
  # end
  
  def service_configuration_variables_for(configurator_name)
    result = engines_api.retrieve_service_configuration(service_name: container_name, configurator_name: configurator_name)
    result.is_a?(EnginesOSapiResult) ? {} : result[:variables]
  end

  # def test(configurator_name)
#     
# 
# p :__call____receive_service_configuration____with_params    
# p :container_name
# p container_name
# p :configurator_name
# p configurator_name
# 
    # engines_api.retrieve_service_configuration(service_name: container_name, configurator_name: configurator_name)
  # end

#instructors  

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

private

  def titles_data
    {
      backup: {title: 'Backup manager', fa_icon: 'history'},
      cert_auth: {title: 'Security certificates', fa_icon: 'certificate'},
      auth: {title: 'Authenticate and authorize', fa_icon: 'key'},
      dns: {title: 'Local DNS server', fa_icon: 'book'},
      dyndns: {title: 'Dynamic DNS', fa_icon: 'bullhorn'},
      ftp: {title: 'Local FTP server', fa_icon: 'upload'},
      mgmt: {title: 'Engines system manager', fa_icon: 'hand-pointer-o'},
      mongo_server: {title: 'Mongo NoSQL database', fa_icon: 'database'},
      mysql_server: {title: 'MySQL database', fa_icon: 'database'},
      nginx: {title: 'Web router', fa_icon: 'random'},
      cAdvisor: {title: 'Activitiy monitor', fa_icon: 'area-chart'},
      wwwstats: {title: 'Web statistics', fa_icon: 'bar-chart'},
      pgsql_server: {title: 'Postgres database', fa_icon: 'database'},
      smtp: {title: 'Outbound mail', fa_icon: 'send-o'},
      volmanager: {title: 'File system manager', fa_icon: 'folder-o'},
      shareservice: {title: 'File system sharing manager', fa_icon: 'share-alt'},
      couriermail: {title: 'Inbound mail', fa_icon: 'inbox'},
      cron: {title: 'Job scheduler', fa_icon: 'calendar'},
      servicemanager: {title: 'Services interaction manager', fa_icon: 'arrows'},
      awsdb: {title: 'AWS database', fa_icon: 'database'},
      email: {title: 'Mail server', fa_icon: 'envelope-o'},
      imap: {title: 'IMAP server', fa_icon: 'envelope-square'},
      syslog: {title: 'System logging', fa_icon: 'file-text-o'},
      nfs: {title: 'Network storage', fa_icon: 'hdd-o'},
    }
  end
 
end