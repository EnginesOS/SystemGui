module Engines::Service

  include Engines::Api
   
#loaders
  
  def system_service_object
    @system_service_object ||= engines_api.getManagedService container_name
  end

#extractors
  
  def human_name
    titles_hash[container_name.to_sym]
  end
  
  def label
    "#{container_name} - #{human_name}"
  end

#inspectors     
  
  def state
    system_service_object.read_state
  end

  def fqdn
    system_service_object.fqdn
  end

  def default_startup_state
    system_service_object.setState
  end

  def memory
    system_service_object.memory
  end

  def framework
    system_service_object.framework
  end

  def runtime
    system_service_object.runtime
  end

  def image
    system_service_object.image
  end

  def repo
    system_service_object.repo
  end

  def port
    system_service_object.port
  end

  def eports
    system_service_object.eports
  end

  def last_error
    system_service_object.last_error
  end

  def last_result
    system_service_object.last_result
  end

  def environments
    system_service_object.environments
  end

  def volumes
    system_service_object.volumes
  end

  def consumers
    system_service_object.registered_consumers
  end

  def stats
    system_service_object.stats
  end

  def ps_container
    system_service_object.ps_container
  end

  def logs_container
    system_service_object.logs_container
  end

  def network_metrics
    engines_api.get_container_network_metrics container_name
  end

  def memory_statistics
    engines_api.get_service_memory_statistics container_name
  end
  
  def type_path
    system_service_object.type_path
  end
  
  def publisher_namespace
    system_service_object.publisher_namespace
  end

  def service_definition
    @service_definition ||= ( engines_api.get_service_definition(type_path, publisher_namespace) || {} )
  end

  def configurators
    configurators_hash.values
  end

  def configurators_hash
    @configurators_hash ||= ( service_definition[:configurators] || {} )
  end

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

  def titles_hash
    {
     backup: 'Backup manager',
     auth: 'Authentication',
     dns: 'Local DNS server',
     dyndns: 'Dynamic DNS',
     ftp: 'Local FTP server',
     mgmt: 'Engines system manager',
     mongo_server: 'Mongo NoSQL database',
     mysql_server: 'MySQL database',
     nginx: 'Web router',
     cAdvisor: 'Activitiy monitor',
     pgsql_server: 'Postgres database',
     smtp: 'Outbound mail',
     volmanager: 'File system manager',
     shareservice: 'File system sharing manager',
     couriermail: 'Inbound mail',
     cron: 'Job scheduler',
     servicemanager: 'Services interaction manager',
     awsdb: 'AWS database',
     email: 'e-mail server',
     imap: 'IMAP interface',
     syslog: 'System logging'
        }
      end
 
end