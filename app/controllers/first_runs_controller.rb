class FirstRunsController < ApplicationController

  include Engines::FirstRun

  def show
    Maintenance.full_maintenance
    if !FirstRun.required?
      @first_run = FirstRun.new first_run_params
      render :show, layout: 'empty_navbar'
    else
      redirect_to(desktop_path)
    end
  end

  def create
    @first_run = FirstRun.new first_run_params
    if @first_run.valid?
      result = Engines::FirstRun.submit(first_run_params)
      if result.was_success
        current_user.update(
          password: first_run_params[:admin_password],
          password_confirmation: first_run_params[:admin_password_confirmation]
          )
        redirect_to control_panel_path, notice: 'First run parameters were successfully saved.'
      else
        redirect_to first_runs_path(first_run: first_run_params), alert: 'First run parameters were not saved. ' + result.result_mesg
      end
    else
      render :show, layout: 'empty_navbar'
    end
  end
  
  def cancel
    sign_out current_user
    redirect_to desktop_path
  end

private

  def first_run_params
    if params[:first_run].nil?
      {
        
      }
    else
      params[:first_run][:ssl_country] = "" if params[:first_run][:ssl_country] == "Select a country..."
      params.require(:first_run).permit!
    end
  end

end