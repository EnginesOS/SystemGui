class BackupTasksController < ApplicationController
  before_action :authenticate_user!

  def index
    # EnginesMaintenance.db_maintenance
    @backup_tasks = BackupTask.all
    @softwares = Software.all
  end

  def new
    @backup_task = BackupTask.new backup_task_params
  end  

  def destroy
    remove_backup_task params[:id]
    redirect_to backup_tasks_path
  end

  def create
    result = BackupTask.new(backup_task_params).save
    if result.was_success == true
      flash[:notice] = result.result_mesg[0..250]
    else
      flash[:error] = "Failed to create backup task. " + result.result_mesg[0..250]
    end
    redirect_to backup_tasks_path 
  end

  private
    def backup_task_params
      params.require(:backup_task).permit!
    end

    def set_backup_task
      @backup_task = BackupTask.find(params[:id])
    end

end