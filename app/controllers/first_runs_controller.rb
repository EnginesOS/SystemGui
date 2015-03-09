class FirstRunsController < ApplicationController

  def first_run
    @first_run = FirstRun.new first_run_params
    render :first_run, layout: 'empty_navbar'
  end

  def submit_first_run
    @first_run = FirstRun.new first_run_params
    if @first_run.valid?
      result = EnginesFirstRun.send_parameters(first_run_params)
      if result.was_success
        current_user.update(
          password: first_run_params[:admin_password],
          password_confirmation: first_run_params[:admin_password_confirmation]
          )
        redirect_to control_panel_path, notice: 'First run parameters were successfully saved.'
      else
        redirect_to first_run_path(first_run: first_run_params), alert: 'First run parameters were not saved. ' + result.result_mesg
      end
    else
      render :first_run, layout: 'empty_navbar'
    end
  end

private

  def first_run_params
    if params[:first_run].nil?
      {
        
      }
    else
      params.require(:first_run).permit!
    end
  end

end