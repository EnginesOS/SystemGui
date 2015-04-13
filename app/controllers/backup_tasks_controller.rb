class BackupTasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @softwares = Software.all
    @softwares.each { |software| software.build_backup_tasks_handler }
  end

  def show
    @software = Software.find(params[:id])
    @software.build_backup_tasks_handler
  end

  def new
    # render text: params
    @software = Software.find(params[:software_id])
    @software.build_backup_tasks_handler
    @backup_task = @software.backup_tasks_handler.backup_tasks.build(backup_task_params)
    @backup_task.load_variables
  end  

  def destroy
    remove_backup_task params[:id]
    redirect_to backup_tasks_path
  end

  def create
    @software = Software.find(params[:software_id])
    @software.build_backup_tasks_handler

    # render text: params

    @backup_task = @software.build_backup_tasks_handler.backup_tasks.build(backup_task_params)
    
    if @backup_task.valid?
      result = @backup_task.save
      if result.was_success == true
        flash[:notice] = result.result_mesg[0..250]
      else
        flash[:error] = "Failed to create backup task. " + result.result_mesg[0..250]
      end
      redirect_to backup_task_path(id: @software.id) 
    else
      render :new
    end
  end

  private

    def backup_task_params
      params.require(:backup_task).permit(:publisher_namespace, :service_handle, :type_path, variables_attributes: [
      :name, :value, :value_confirmation, :label, :field_type, :select_collection, :tooltip, :hint, :placeholder, 
      :comment, :regex_validator, :regex_invalid_message, :mandatory, :ask_at_build_time, :build_time_only, :immutable
    ])
    end

    # def set_backup_task
      # @backup_task = BackupTask.find(params[:id])
    # end

end