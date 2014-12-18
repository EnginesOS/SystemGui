module EnginesBackupTask

  # include EnginesApi
  extend EnginesApi

  def self.select engines_backup_task_name
    engines_api.load_backup backup_task_name
  end

  def self.remove engines_backup_task_name
    engines_api.stop_backup backup_task_name
  end

  def self.save engines_backup_task_params
    if engines_backup_task_params[:backup_type] == "fs"
      create_volume_backup_task engines_backup_task_params
    elsif engines_backup_task_params[:backup_type] == "db"
      create_database_backup_task engines_backup_task_params
    else
      false
    end
  end

  def self.all
    engines_api.get_backups.values
  end









#   def self.all_grouped_by_engine_and_type

#     all.group_by{|backup_task| backup_task[:engine_name]}.each.group_by{|backup_task| backup_task[:backup_type]}


# #     application_backup_details = {}
# #     application_backup_tasks = {}

# #     backup_tasks = all
# #     applications = EnginesSoftware.all

# # p 'backup_tasks'
# # p backup_tasks
# # p 'applications'
# # p applications

# #     backup_tasks.each do |backup_task|
# #       backup_task_name = backup_task[:backup_name]
# #       backup_task_application_name = backup_task[:engine_name]
# #       backup_task_source_name = backup_task[:source_name]
# #       backup_task_type = backup_task[:backup_type]

# #       if application_backup_tasks[backup_task_application_name].nil?
# #         application_backup_tasks[backup_task_application_name] = {}
# #       end
# #       if application_backup_tasks[backup_task_application_name][backup_task_type].nil?
# #         application_backup_tasks[backup_task_application_name][backup_task_type] = {}
# #       end
# #       if application_backup_tasks[backup_task_application_name][backup_task_type][backup_task_source_name].nil?
# #         application_backup_tasks[backup_task_application_name][backup_task_type][backup_task_source_name] = []
# #       end
# #       temp = application_backup_tasks[backup_task_application_name][backup_task_type][backup_task_source_name]
# #       temp << backup_task_name     
# #       application_backup_tasks[backup_task_application_name][backup_task_type][backup_task_source_name] = temp
# #     end

# #     applications.each do |application|
# #       application_name = application.host_name
# #       application_volume_names = application.volumes.map(&:name).reject(&:blank?)
# #       application_database_names = application.databases.map(&:name).reject(&:blank?)

# #       application_volumes = []
# #       application_volume_names.each do |application_volume_name|       
# #         if application_backup_tasks[application_name].present? && application_backup_tasks[application_name]["fs"].present? && application_backup_tasks[application_name]["fs"][application_volume_name].present?
# #           backup_tasks = application_backup_tasks[application_name]["fs"][application_volume_name]
# #         else
# #           backup_tasks = []
# #         end
# #         application_volumes << {name: application_volume_name, backup_tasks: backup_tasks}
# #       end

# #       application_databases = []
# #       application_database_names.each do |application_database_name|
# #         if application_backup_tasks[application_name].present? && application_backup_tasks[application_name]["db"].present? && application_backup_tasks[application_name]["db"][application_database_name].present?
# #           backup_tasks = application_backup_tasks[application_name]["db"][application_database_name]
# #         else
# #           backup_tasks = []
# #         end
# #         application_databases << {name: application_database_name, backup_tasks: backup_tasks}
# #       end

# #       application_backup_details[application_name] = {
# #         volumes: application_volumes,
# #         databases: application_databases
# #       }
# #     end

# # p 'application_backup_details'
# # p application_backup_details

# #     return application_backup_details
  
#   end






private

  def create_volume_backup_task engines_backup_task_params
    engines_api.backup_volume(
      engines_backup_task_params[:backup_name],
      engines_backup_task_params[:engine_name],
      engines_backup_task_params[:source_name],
      engines_backup_task_params[:destination_hash])
  end

  def create_database_backup_task
    engines_api.backup_database(
      engines_backup_task_params[:backup_name],
      engines_backup_task_params[:engine_name],
      engines_backup_task_params[:source_name],
      engines_backup_task_params[:destination_hash])
  end

end