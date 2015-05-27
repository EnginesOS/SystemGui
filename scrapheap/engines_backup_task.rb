module EnginesBackupTask

  extend EnginesApi
# 
  # def self.select(engines_backup_task_name)
    # engines_api.load_backup backup_task_name
  # end
# 
  # def self.remove(engines_backup_task_name)
    # engines_api.stop_backup backup_task_name
  # end

  # def self.save(engines_backup_task_params)
    # engines_api.backup_service(
    # {
      # # publisher_namespace:
      # # type_path:
      # # service_handle:
      # # parent_service:
        # # {
          # # publisher_namespace:
          # # type_path:
          # # service_handle:
        # # }
      # # engine_name: 
      # # variables: {
# #         
      # # }
    # })
#      
    # # if engines_backup_task_params[:backup_type] == "fs"
      # # engines_api.backup_volume engines_backup_task_params
    # # elsif engines_backup_task_params[:backup_type] == "db"
      # # engines_api.backup_database engines_backup_task_params
    # # else
      # # false
    # # end
  # end

  # def self.all
    # @all_backups ||= engines_api.get_backups.values
  # end

  def self.backup_service_definition(type_path, publisher_namespace)
    @backup_service_definition ||= 
      engines_api.default_backup_service_definition({
        publisher_namespace: publisher_namespace,
        type_path: type_path
      })
  end

  # def self.count
    # all.count
  # end

end