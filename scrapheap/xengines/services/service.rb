module Engines::Services
   
    class Service
      
      include Engines::Api
      
      def initialize(name)
        @name = name.to_s
        
      end
      
      attr_reader :name

#loaders
      
      def system_service_object
        @system_service_object ||= engines_api.getManagedService @name
      end

#extractors
      
      def human_name
        titles_hash[name.to_sym]
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
  
      def volumes_hash
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
        Engines::System.api.get_container_network_metrics @name
      end
  
      def memory_statistics
        Engines::System.api.get_service_memory_statistics @name
      end

#instructors  
  
      def stop
        Engines::System.api.stopService @name
      end
  
      def start
        Engines::System.api.startService @name
      end
  
      def pause
        Engines::System.api.pauseService @name
      end
  
      def unpause
        Engines::System.api.unpauseService @name
      end
  
      def create_container
        Engines::System.api.createService @name
      end
  
      def recreate
        Engines::System.api.recreateService @name
      end

    private
  
      def titles_hash
        {
         backup: 'Backup manager',
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
         couriermail: 'Inbound mail service',
         cron: 'Job scheduler',
         servicemanager: 'Services interaction manager',
         awsdb: 'AWS database',
         email: 'e-mail server',
         imap: 'IMAP interface',
         syslog: 'System logging'
        }
      end
        

  
    end


end