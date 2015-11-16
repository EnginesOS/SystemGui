module Engines::Services

  def self.titles_data
    {
      backup: {title: 'Backup manager', fa_icon: 'history'},
      cert_auth: {title: 'Security certificates', fa_icon: 'certificate'},
      auth: {title: 'Authenticate and authorize', fa_icon: 'key'},
      dhcpd: {title: 'DHCP server', fa_icon: 'tags'},
      dns: {title: 'Domain name resolution', fa_icon: 'book'},
      dyndns: {title: 'Dynamic IP address hosting', fa_icon: 'bullhorn'},
      ftp: {title: 'File transfer', fa_icon: 'upload'},
      mgmt: {title: 'Engines system manager', fa_icon: 'dashboard'},
      mongo_server: {title: 'Database', fa_icon: 'database'},
      mysql_server: {title: 'Database', fa_icon: 'database'},
      nginx: {title: 'Web router', fa_icon: 'random'},
      cAdvisor: {title: 'Activitiy monitor', fa_icon: 'area-chart'},
      wwwstats: {title: 'Web analytics', fa_icon: 'bar-chart'},
      pgsql_server: {title: 'Database', fa_icon: 'database'},
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
      avahi: {title: 'Service discovery', fa_icon: 'map-signs'}
    }
  end
  
end