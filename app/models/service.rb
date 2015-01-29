class Service

  def self.human_name service_name
    {
     backup: 'Backup manager',
     dns: 'Local DNS server',
     ftp: 'Local FTP server',
     mgmt: 'Engines system manager',
     mongo_server: 'Mongo NoSQL database',
     mysql_server: 'MySQL database',
     nginx: 'Web router',
     cAdvisor: 'Activitiy logger',
     pgsql_server: 'Postgres database',
     smtp: 'Outbound mail',
     volmanager: 'File system manager',
     shareservice: 'File system sharing',
     couriermail: 'Inbound mail',
     cron: 'Job scheduler',
     servicemanager: 'Controls services interaction'
    }[service_name.to_sym]
  end

end