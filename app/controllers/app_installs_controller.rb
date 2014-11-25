class AppInstallsController < ApplicationController
  before_action :authenticate_user!
  include ActionController::Live
  require 'open3'

  def new
    @app_install = AppInstall.new_with_defaults app_install_params
  end

  def edit
    @app_install = AppInstall.find_by(engine_name: params[:id])
    if @app_install.nil?
      @app_install = AppInstall.new_from_engine(params[:id])
    else
      @app_install.refresh_host_name_and_domain_name
p @app_install.inspect
    end
  end

  def create
    check_license_terms_and_conditions_accepted || commit_create
  end

  def check_license_terms_and_conditions_accepted
    if app_install_params["terms_and_conditions_accepted"] == "0"
     return redirect_to new_app_install_path(app_install: app_install_params), notice: 'You must accept the license terms and conditions to install this software.'
    end
  end

  def commit_create
    app_install = AppInstall.new(app_install_params)
    if app_install.build_app.instance_of?(ManagedEngine)
      if app_install.save
        redirect_to app_manager_path, notice: 'Application installation was successful.'
      else
        redirect_to installer_path, alert: 'Application installed but not configured. Edit the app in the App Manager to complete app configuration.'
      end
    else
      redirect_to installer_path, alert: 'Application installation was not successful.'
    end
  end

  def update
    if app_install_params['created_from_existing_engine'] == 'true'
      app_install = AppInstall.new(app_install_params)
      if app_install.save
        redirect_to app_manager_path, notice: 'Application details were successfully updated.'
      else
        render :edit, alert: 'Application details were not updated.'
      end
    else
      app_install = AppInstall.find(params[:id])
      if app_install.update(app_install_params)
        if app_install.update_app_engine == true
          redirect_to app_manager_path, notice: 'Application details were successfully updated.'
        else
          redirect_to app_manager_path, alert: 'Display properties updated, but application host name and domain name not updated.'
        end
      else
        render :edit, alert: 'Application details were not updated.'
      end
    end
    # redirect_to app_manager_path
  end

  def destroy
    @install.destroy
    respond_to do |format|
      format.html { redirect_to installs_url, notice: 'Install was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def installing
    response.headers['Content-Type'] = 'text/event-stream'

    begin
      follow_log do |line| 
        response.stream.write line
      end

    rescue IOError

    ensure
      logger.info("Killing stream")
      response.stream.close
    end

  end

private

  def app_install_params
    params.require(:app_install).permit!
  end

  def follow_log
    begin
      stdin, stdout, stderr, wait_thread = Open3.popen3("tail -F -n 0 /tmp/build.out")

      stdout.each_line do |line|
        yield line
      end

    rescue IOError

    ensure
      stdin.close
      stdout.close
      stderr.close
      Process.kill('HUP', wait_thread[:pid])
      logger.info("Killing Tail pid: #{wait_thread[:pid]}")
    end
  end


end
