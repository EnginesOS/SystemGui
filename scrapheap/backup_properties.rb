class BackupTasksHandler < ActiveRecord::Base

  has_many :backup_tasks
  belongs_to :software

  # accepts_nested_attributes_for :variables



  # def count
    # EnginesBackupTask.count
  # end
# 
  # def self.all
    # EnginesBackupTask.all.map do |engines_backup_task|
      # BackupTask.new(
        # source_name: engines_backup_task[:source_name],
        # backup_type: engines_backup_task[:backup_type],
        # engine_name: engines_backup_task[:engine_name],
        # backup_name: engines_backup_task[:backup_name],
        # protocol: engines_backup_task[:dest_proto],
        # address: engines_backup_task[:dest_address],
        # folder: engines_backup_task[:dest_folder],
        # username: engines_backup_task[:dest_user],
        # password: engines_backup_task[:dest_pass])
    # end
  # end    

  def backupable_services
    if @backupable_services.nil?
      @backupable_services = EnginesSoftware.persistant_attached_services(software.engine_name).map do |backupable_service|
        service_detail = EnginesAttachedService.service_detail_for(backupable_service[:type_path], backupable_service[:publisher_namespace])
        {
          title: service_detail[:title],
          description: service_detail[:description],
          publisher_namespace: service_detail[:publisher_namespace],
          type_path: service_detail[:type_path],
          service_handle: service_detail[:service_handle]
          # ,
          # variables_attributes: service_detail[:variables_attributes]
        }
      end
    end
    @backupable_services
  end

private



end