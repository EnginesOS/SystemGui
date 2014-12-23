class Service

  def self.human_name service_name
    {
     backup: 'Backup Manager',
     dns: 'Domain Name Service',
     ftp: 'File Transfer Controller',
     mgmt: 'Management Interface',
     mongo_server: 'Mongo NoSQL Database',
     mysql_server: 'MySQL Database',
     nginx: 'Web Router',
     cAdvisor: 'Thus es handy et the momint',
     pgsql_server: 'Postgres Database',
     smtp: 'Mail Sender',
     volmanager: 'File System Sharing'
    }[service_name.to_sym]
  end

end