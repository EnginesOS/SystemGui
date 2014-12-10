class BackupTask

  include ActiveModel::Model
  # include Engines::Api

  attr_accessor :source_name
  attr_accessor :backup_type
  attr_accessor :engine_name
  attr_accessor :backup_name
  attr_accessor :protocol
  attr_accessor :address
  attr_accessor :folder
  attr_accessor :username
  attr_accessor :password

  def initialize params
    @source_name = params[:source_name]
    @backup_type = params[:backup_type]
    @engine_name = params[:engine_name]
    @backup_name = params[:backup_name] || ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(8).join  
    @protocol = params[:protocal] || "ftp"
    @address = params[:address]
    @folder = params[:engine_name] || @engine_name
    @username = params[:engine_name]
    @password = params[:engine_name]
  end

  def self.engines_api
    EnginesApiHandler.engines_api
  end

  def engines_api
    EnginesApiHandler.engines_api
  end

  def self.find id
    engines_api.load_backup(id)
  end

  def backup_type_in_words
    result = 'unknown backup type'
    result = 'files' if backup_type == 'fs'
    result = 'database' if backup_type == 'db'
    return result
  end

  def remove_backup_task
    engines_api.stop_backup @id
  end

  def save
    # @backup_type == "fs" ? create_volume_backup_task || create_database_backup_task
    if @backup_type == "fs"
      create_volume_backup_task
    else
      create_database_backup_task
    end
  end

  def create_volume_backup_task
    engines_api.backup_volume(@backup_name, @engine_name, @source_name, destination_params)
  end

  def create_database_backup_task
    engines_api.backup_database(@backup_name, @engine_name, @source_name, destination_params)
  end

  def self.all
    self.engines_api.get_backups
  end

  def self.count
    self.all.keys.count
  end

  def self.all_grouped_by_app

    application_backup_details = {}
    application_backup_tasks = {}

    backup_tasks = self.all
    applications = AppHandler.all

    backup_tasks.keys.each do |backup_task_name|
      backup_task_application_name = backup_tasks[backup_task_name][:engine_name]
      backup_task_source_name = backup_tasks[backup_task_name][:source_name]
      backup_task_type = backup_tasks[backup_task_name][:backup_type]

      if application_backup_tasks[backup_task_application_name].nil?
        application_backup_tasks[backup_task_application_name] = {}
      end
      if application_backup_tasks[backup_task_application_name][backup_task_type].nil?
        application_backup_tasks[backup_task_application_name][backup_task_type] = {}
      end
      if application_backup_tasks[backup_task_application_name][backup_task_type][backup_task_source_name].nil?
        application_backup_tasks[backup_task_application_name][backup_task_type][backup_task_source_name] = []
      end
      temp = application_backup_tasks[backup_task_application_name][backup_task_type][backup_task_source_name]
      temp << backup_task_name     
      application_backup_tasks[backup_task_application_name][backup_task_type][backup_task_source_name] = temp
    end

    applications.each do |application|
      application_name = application.host_name
      application_volume_names = application.volumes.map(&:name).reject(&:blank?)
      application_database_names = application.databases.map(&:name).reject(&:blank?)

      application_volumes = []
      application_volume_names.each do |application_volume_name|       
        if application_backup_tasks[application_name].present? && application_backup_tasks[application_name]["fs"].present? && application_backup_tasks[application_name]["fs"][application_volume_name].present?
          backup_tasks = application_backup_tasks[application_name]["fs"][application_volume_name]
        else
          backup_tasks = []
        end
        application_volumes << {name: application_volume_name, backup_tasks: backup_tasks}
      end

      application_databases = []
      application_database_names.each do |application_database_name|
        if application_backup_tasks[application_name].present? && application_backup_tasks[application_name]["db"].present? && application_backup_tasks[application_name]["db"][application_database_name].present?
          backup_tasks = application_backup_tasks[application_name]["db"][application_database_name]
        else
          backup_tasks = []
        end
        application_databases << {name: application_database_name, backup_tasks: backup_tasks}
      end

      application_backup_details[application_name] = {
        volumes: application_volumes,
        databases: application_databases
      }
    end

    return application_backup_details
  
  end

private

  def destination_params
    {
      dest_proto: @protocol,
      dest_address: @address,
      dest_user: @username,
      dest_pass: @password,
      dest_folder: @folder
    }
  end

end