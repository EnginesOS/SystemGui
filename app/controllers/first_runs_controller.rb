class FirstRunsController < ApplicationController


  # include Engines::FirstRun

  def show
      @first_run = FirstRun.new(system_hostname: System.system_hostname)
      render :show, layout: 'empty_navbar'
  end

  def create
    #
    # uncomment once James finished testing first run form. Form will then submit once only.
    #
    if true # FirstRun.required? && current_user.valid_password?('password')
      @first_run = FirstRun.new first_run_params
      if @first_run.valid?
        result = @first_run.submit
        if result.was_success
          current_user.update(
            email: first_run_params[:admin_email],
            password: first_run_params[:admin_password],
            password_confirmation: first_run_params[:admin_password_confirmation],
            )
          flash[:notice] = 'The setup wizard ran successfully. Please sign in again, using your new admin password.'
          redirect_to desktop_path
        else
          flash[:alert] =  'There was a problem with the setup wizard. ' + result.result_mesg[0..500]
          render :show, layout: 'empty_navbar'
        end
      else
        render :show, layout: 'empty_navbar'
      end
    else
      flash[:alert] = 'The setup wizard has already been run and cannot be run again.'
      redirect_to(desktop_path)
    end
  end

  def cancel
    sign_out current_user
    redirect_to desktop_path
  end

private

  def first_run_params
      params[:first_run][:ssl_country] = "" if params[:first_run][:ssl_country] == "Select a country..."
      params.require(:first_run).permit!
  end

end
