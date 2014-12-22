class BackupTask

  include ActiveModel::Model

  attr_accessor(
    :source_name,
    :backup_type,
    :engine_name,
    :backup_name,
    :protocol,
    :address,
    :folder,
    :username,
    :password)

  def initialize params
    @source_name = params[:source_name]
    @backup_type = params[:backup_type]
    @engine_name = params[:engine_name]
    @backup_name = params[:backup_name] || default_backup_name  
    @protocol = params[:protocal] || "ftp"
    @address = params[:address]
    @folder = params[:folder] || params[:engine_name]
    @username = params[:username]
    @password = params[:password]
  end

  def backup_type_in_words
    case backup_type
    when 'fs'; 'files'
    when 'db'; 'database'
    else 'unknown backup type'
    end
  end

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

private

  def engines_backup_task_params
    {
      backup_name: @backup_name,
      backup_type: @backup_type,
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