class BackupTasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @application_backup_details = get_application_backup_details
  end

  def new
    @backup_task = BackupTask.new
    @backup_task.set_defaults params
  end  

  def destroy
    remove_backup_task params[:id]
    redirect_to backup_tasks_path
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

    if type == "fs"
      volume_name = source_name
      engines_api.backup_volume(backup_name,engine_name,volume_name,dest_hash)
    else
      database_name = source_name
      engines_api.backup_database(backup_name,engine_name,database_name,dest_hash)
    end

    redirect_to backup_tasks_path
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