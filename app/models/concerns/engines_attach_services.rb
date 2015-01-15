module EnginesAttachServices

  extend EnginesApi

  def self.available_services_for object
    engines_api.list_avail_services_for object

# { 
#   services: [
#     {author: "Engines", description: "Provides persistent volumes.", service_name: "volmanger" , title: "Volume service", accepts: ["ManagedEngine","ManagedService"], dedicated: false},
#     {author: "Engines", description: "Provides task scheduling for engines.", service_name: "cron" , title: "Task scheduler", accepts: ["ManagedEngine","ManagedService"], dedicated: false}
#   ],
#   components: {
#     volumes: [
#       {
#       name: 'website',
#       component_services: {
#         engines_ftp: {title: "FTP Server", accepts: ["Volume"] , description: "Allows sharing of folders via FTP."},
#         dropbox: {title: "Dropbox sync", accepts: ["Volume"], description: "Sync your folders with a Dropbox account."},
#         default_editor: {title: "An editor", accepts: ["Volume"], description: "Direct editing of files in a folder."}
#         }
#       }
#     ]
#   }
# }

  end





end