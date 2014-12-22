module EnginesBackupTask

  extend EnginesApi

  def self.select(engines_backup_task_name)
    engines_api.load_backup backup_task_name
  end

  def self.remove(engines_backup_task_name)
    engines_api.stop_backup backup_task_name
  end

  def self.save(engines_backup_task_params)
    if engines_backup_task_params[:backup_type] == "fs"
      engines_api.backup_volume engines_backup_task_params
    elsif engines_backup_task_params[:backup_type] == "db"
      engines_api.backup_database engines_backup_task_params
    else
      false
    end
  end

  def self.all
    @all_backups ||= engines_api.get_backups.values
  end

  def self.count
    all.count
  end

# private

#   def self.create_volume_backup_task engines_backup_task_params
#     engines_api.backup_volume(
#       engines_backup_task_params[:backup_name],
#       engines_backup_task_params[:engine_name],
#       engines_backup_task_params[:source_name],
#       engines_backup_task_params[:destination_hash])
#   end

#   def self.create_database_backup_task engines_backup_task_params
#     engines_api.backup_database(
#       engines_backup_task_params[:backup_name],
#       engines_backup_task_params[:engine_name],
#       engines_backup_task_params[:source_name],
#       engines_backup_task_params[:destination_hash])
#   end

end