# require "/opt/engines/lib/ruby/EnginesOSapi.rb"

# module EnginesApiHandlerX

#   def engines_api
#     if $enginesOS_api == nil
#       $enginesOS_api = EnginesOSapi.new
#     end
#     return $enginesOS_api
#   end

#   def get_all_applications
#     return (engines_api.getManagedEngines() || [])
#   end

#   def user_visible_applications
#     return get_all_applications.select{|e| e.setState == "running"}
#   end

#   def get_all_backups
#     engines_api.get_backups
#   end

#   def remove_backup_task id
#     engines_api.stop_backup id
#   end

#   def get_application_backup_details

#     application_backup_details = {}
#     application_backup_tasks = {}

#     backup_tasks = get_all_backups
#     applications = get_all_applications

#     backup_tasks.keys.each do |backup_task_name|
#       backup_task_application_name = backup_tasks[backup_task_name][:engine_name]
#       backup_task_source_name = backup_tasks[backup_task_name][:source_name]
#       backup_task_type = backup_tasks[backup_task_name][:backup_type]

#       if application_backup_tasks[backup_task_application_name].nil?
#         application_backup_tasks[backup_task_application_name] = {}
#       end
#       if application_backup_tasks[backup_task_application_name][backup_task_type].nil?
#         application_backup_tasks[backup_task_application_name][backup_task_type] = {}
#       end
#       if application_backup_tasks[backup_task_application_name][backup_task_type][backup_task_source_name].nil?
#         application_backup_tasks[backup_task_application_name][backup_task_type][backup_task_source_name] = []
#       end
#       temp = application_backup_tasks[backup_task_application_name][backup_task_type][backup_task_source_name]
#       temp << backup_task_name     
#       application_backup_tasks[backup_task_application_name][backup_task_type][backup_task_source_name] = temp
#     end

#     applications.each do |application|
#       application_name = application.hostName
#       application_volume_names = application.volumes.map(&:name).reject(&:blank?)
#       application_database_names = application.databases.map(&:name).reject(&:blank?)

#       application_volumes = []
#       application_volume_names.each do |application_volume_name|       
#         if application_backup_tasks[application_name].present? && application_backup_tasks[application_name]["fs"].present? && application_backup_tasks[application_name]["fs"][application_volume_name].present?
#           backup_tasks = application_backup_tasks[application_name]["fs"][application_volume_name]
#         else
#           backup_tasks = []
#         end
#         application_volumes << {name: application_volume_name, backup_tasks: backup_tasks}
#       end

#       application_databases = []
#       application_database_names.each do |application_database_name|
#         if application_backup_tasks[application_name].present? && application_backup_tasks[application_name]["db"].present? && application_backup_tasks[application_name]["db"][application_database_name].present?
#           backup_tasks = application_backup_tasks[application_name]["db"][application_database_name]
#         else
#           backup_tasks = []
#         end
#         application_databases << {name: application_database_name, backup_tasks: backup_tasks}
#       end

#       application_backup_details[application_name] = {
#         volumes: application_volumes,
#         databases: application_databases
#       }
#     end

#     return application_backup_details
  
#   end


# ### App actions

#   def build_app repository, params
#     engines_api.build_engine(repository, params)
#   end

#   # def load_app id
#   #   engines_api.loadManagedEngine(id)
#   # end

#   def stop_app id
#     result = engines_api.stopEngine(id)
#     return result.result_mesg
#   end
  
#   def start_app id   
#     result = engines_api.startEngine(id)
#     return result.result_mesg
#   end
  
#   def pause_app id
#     result = engines_api.pauseEngine(id)
#     return result.result_mesg
#   end
  
#   def unpause_app id
#     result = engines_api.unpauseEngine(id)
#     return result.result_mesg
#    end
   
#   def destroy_container_app id
#     result = engines_api.destroyEngine(id)
#     return result.result_mesg
#   end 
  
#   def delete_image_app id
#     result = engines_api.deleteEngineImage(id)
#     return result.result_mesg
#   end 
  
#   def restart_app id
#     result = engines_api.restartEngine(id)
#     return result.result_mesg
#   end
  
#   def create_container_app id
#     result = engines_api.createEngine(id)
#     return result.result_mesg
#   end

#   def recreate_app id
#     result = engines_api.recreateEngine(id)
#     return result.result_mesg
#   end

#   def monitor_app id
#     result = engines_api.monitorEngine(id)
#     return result.result_mesg
#   end
  
#   def demonitor_app id
#     result = engines_api.demonitorEngine(id)
#     return result.result_mesg
#   end
  
#   def register_website_app id
#     result = engines_api.registerEngineWebSite(id)
#     return result.result_mesg
#   end
  
#   def deregister_website_app id
#     result = engines_api.deregisterEngineWebSite(id)    
#      return result.result_mesg
#   end
  
#   def register_dns_app id
#     result = engines_api.registerEngineDNS(id)
#     return result.result_mesg
#   end
  
#   def deregister_dns_app id
#     result = engines_api.deregisterEngineDNS(id)    
#     return result.result_mesg
#   end
  
# ### Service actions

#   def stop_service id
#     @result = engines_api.stopService id
#     @notice = @result.result_mesg
#   end

#   def start_service id
#     @result = engines_api.startService id
#     @notice = @result.result_mesg
#   end
     
#   def pause_service id
#     @result = engines_api.pauseService id
#     @notice = @result.result_mesg
#   end
    
#   def unpause_service id
#     @result = engines_api.unpauseService id
#     @notice = @result.result_mesg
#   end
    
#   def register_website_service id
#     @result = engines_api.registerServiceWebSite id
#     @notice = @result.result_mesg
#   end
   
#   def deregister_website_service id
#     @result = engines_api.deregisterServiceWebSite id
#     @notice = @result.result_mesg
#   end

#   def register_dns_service id
#     @result = engines_api.registerServiceDNS id
#     @notice = @result.result_mesg
#   end
   
#   def deregister_dns_service id
#     @result = engines_api.deregisterServiceDNS id
#     @notice = @result.result_mesg
#   end

#   def create_container_service id
#     @result = engines_api.createService id
#     @notice = @result.result_mesg
#   end
    
#   def recreate_service id
#     @result = engines_api.recreateService id
#     @notice = @result.result_mesg
#   end

# end


