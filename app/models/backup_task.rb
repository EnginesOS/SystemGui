class BackupTask

  include ActiveModel::Model

  attr_accessor(
    :source_name,
    :type_path,
    :engine_name,
    :backup_name,
    :protocol,
    :address,
    :folder,
    :username,
    :password)

  def initialize params
#    type_path: @type_path,
#      publisher_namespace: @publisher_namespace,
#      service_handle:
#    

p :backup_params
p params

    @source_name = params[:source_name]
    @type_path = params[:type_path]
    @engine_name = params[:engine_name]
    @backup_name = params[:backup_name] || default_backup_name  
    @protocol = params[:protocal] || "ftp"
    @address = params[:address]
    @folder = params[:folder] || params[:engine_name]
    @username = params[:username]
    @password = params[:password]
  end

  # def backup_type_in_words
    # case backup_type.to_s
    # when 'fs'
      # 'files'
    # when 'db'
      # 'database'
    # else
      # 'unknown backup type'
    # end
  # end

  def count
    EnginesBackupTask.count
  end

  def save
    EnginesBackupTask.save engines_backup_task_params
  end

  def self.all
    EnginesBackupTask.all.map do |engines_backup_task|
      self.new(
        source_name: engines_backup_task[:source_name],
        backup_type: engines_backup_task[:backup_type],
        engine_name: engines_backup_task[:engine_name],
        backup_name: engines_backup_task[:backup_name],
        protocol: engines_backup_task[:dest_proto],
        address: engines_backup_task[:dest_address],
        folder: engines_backup_task[:dest_folder],
        username: engines_backup_task[:dest_user],
        password: engines_backup_task[:dest_pass])
    end
  end    

  def self.backupable_services(engine_name)
    if @backupable_services.nil?
      @backupable_services = EnginesSoftware.persistant_attached_services(engine_name).map do |backupable_service|
        service_detail = EnginesAttachedService.service_detail_for(backupable_service[:type_path], backupable_service[:publisher_namespace])
        backupable_service[:title] = service_detail[:title]
        backupable_service[:description] = service_detail[:description]
        backupable_service
      end
    end
    @backupable_services
  end


private

  def engines_backup_task_params
    {
      backup_name: @backup_name,
      type_path: @backup_type,
      publisher_namespace: @publisher_namespace,
      service_handle: @service_handle,
      engine_name: @engine_name,
      source_name: @source_name,
      destination_hash: {
        dest_proto: @protocol,
        dest_address: @address,
        dest_user: @username,
        dest_pass: @password,
        dest_folder: @folder
      }
    }
  end

  def default_backup_name
    ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(8).join
  end
  
end