class BackupTasksController < ApplicationController
  before_action :authenticate_user!


  def index
    @backup_tasks = $enginesOS_api.get_backups
    @engines = $enginesOS_api.getManagedEngines()
    @engines ||= []

    @engine_backup_tasks = {}
    @backup_tasks.keys.each do |backup_task_name|
      backup_tasks_engine_name = @backup_tasks[backup_task_name][:engine_name]
      backup_tasks_source_name = @backup_tasks[backup_task_name][:source_name]
      backup_tasks_type = @backup_tasks[backup_task_name][:backup_type]

      if @engine_backup_tasks[backup_tasks_engine_name].nil?
        @engine_backup_tasks[backup_tasks_engine_name] = {}
      end
      if @engine_backup_tasks[backup_tasks_engine_name][backup_tasks_type].nil?
        @engine_backup_tasks[backup_tasks_engine_name][backup_tasks_type] = {}
      end
      if @engine_backup_tasks[backup_tasks_engine_name][backup_tasks_type][backup_tasks_source_name].nil?
        @engine_backup_tasks[backup_tasks_engine_name][backup_tasks_type][backup_tasks_source_name] = []
      end
      temp = @engine_backup_tasks[backup_tasks_engine_name][backup_tasks_type][backup_tasks_source_name]
      temp << backup_task_name     
      @engine_backup_tasks[backup_tasks_engine_name][backup_tasks_type][backup_tasks_source_name] = temp
    end

    @engines_with_backup_details = {}
    @engines.each do |engine|
      engine_name = engine.hostName
      engine_volume_names = engine.volumes.map(&:name).reject(&:blank?)
      engine_database_names = engine.databases.map(&:name).reject(&:blank?)

      engine_volumes = []
      engine_volume_names.each do |engine_volume_name|       
        if @engine_backup_tasks[engine_name].present? && @engine_backup_tasks[engine_name]["fs"].present? && @engine_backup_tasks[engine_name]["fs"][engine_volume_name].present?
          backup_tasks = @engine_backup_tasks[engine_name]["fs"][engine_volume_name]
        else
          backup_tasks = []
        end
        engine_volumes << {name: engine_volume_name, backup_tasks: backup_tasks}
      end

      engine_databases = []
      engine_database_names.each do |engine_database_name|
        if @engine_backup_tasks[engine_name].present? && @engine_backup_tasks[engine_name]["db"].present? && @engine_backup_tasks[engine_name]["db"][engine_database_name].present?
          backup_tasks = @engine_backup_tasks[engine_name]["db"][engine_database_name]
        else
          backup_tasks = []
        end
        engine_databases << {name: engine_database_name, backup_tasks: backup_tasks}
      end

      @engines_with_backup_details[engine_name] = {
        volumes: engine_volumes,
        databases: engine_databases
      }
    end

  end

  def new
    @backup_task = BackupTask.new
    @backup_task.source_name = params[:source_name]
    @backup_task.backup_type = params[:backup_type]
    @backup_task.engine_name = params[:engine_name]
    @backup_task.backup_name = ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(8).join  
    @backup_task.protocol = "ftp"
    @backup_task.address = ""
    @backup_task.folder = @backup_task.engine_name
    @backup_task.username = ""
    @backup_task.password = ""
  end  

  def destroy
    $enginesOS_api.stop_backup params[:id]
    redirect_to backup_path
  end

  def create
    params = backup_task_params
    source_name = params[:source_name]
    type = params[:backup_type]
    engine_name = params[:engine_name]
    backup_name = params[:backup_name]
    dest_hash = {
      dest_proto: params[:protocol],
      dest_address: params[:address],
      dest_user: params[:username],
      dest_pass: params[:password],
      dest_folder: params[:folder]
    }

p    source_name
p    type
p    engine_name
p    backup_name
p    dest_hash
p params

    if type == "fs"
      volume_name = source_name
      $enginesOS_api.backup_volume(backup_name,engine_name,volume_name,dest_hash)
    else
      database_name = source_name
      $enginesOS_api.backup_database(backup_name,engine_name,database_name,dest_hash)
    end

    redirect_to backup_path
  end

  private
    def backup_task_params
      params.require(:backup_task).permit( \
        :source_name, \
        :backup_type, \
        :engine_name, \
        :backup_name, \
        :protocol, \
        :address, \
        :username, \
        :address, \
        :password, \
        :folder )
    end


end