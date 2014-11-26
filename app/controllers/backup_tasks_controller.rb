class BackupTasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @application_backup_details = BackupTask.all_grouped_by_app
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
    if backup_task_params[:backup_type] == "fs"
      result = BackupTask.create_volume_backup_task(backup_task_params)
    else
      result = BackupTask.create_database_backup_task(backup_task_params)
    end

    if result.was_success == true
      flash[:notice] = result.result_mesg
    else0
      flash[:error] = result.result_mesg
    end
    redirect_to backup_tasks_path 
  end

  private
    def backup_task_params
      params.require(:backup_task).permit!
      # ( \
      #   :source_name, \
      #   :backup_type, \
      #   :engine_name, \
      #   :backup_name, \
      #   :protocol, \
      #   :address, \
      #   :username, \
      #   :address, \
      #   :password, \
      #   :folder )
    end

    def set_backup_task
      @backup_task = BackupTask.find(params[:id])
    end

end