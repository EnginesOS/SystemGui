class FirstRunsController < ApplicationController

  def first_run
    @first_run = FirstRun.new first_run_params
    render :first_run, layout: 'first_run'
  end

  def submit_first_run
    @first_run = FirstRun.new first_run_params
    if @first_run.valid?
      result = EnginesFirstRun.send_parameters(first_run_params)
      if result.was_success
        redirect_to control_panel_path, notice: 'First run parameters were successfully saved.'
      else
        redirect_to first_run_path(first_run: first_run_params), alert: 'First run parameters were not saved. ' + result.result_mesg
      end
    else
      render :first_run
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