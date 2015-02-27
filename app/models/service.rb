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
    }[service_name.to_sym]
  end

end