class AppInstallsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_install, only: [
    :edit_display_properties,
    :edit_runtime_properties,
    :edit_network_properties,
    :update_display_properties,
    :update_network_properties,
    :update_runtime_properties]
  # before_action :set_app_install, only: [:edit_display_properties]
  before_action :refresh_app_install_engine_data, only: [
    :edit_runtime_properties,
    :edit_network_properties]

  def refresh_app_install_engine_data
    @app_install.refresh_engine_data
  end

  def new
    Maintenance.db_maintenance
    @app_install = AppInstall.new_from_gallery app_install_params
  end

  def create

    if app_install_params["terms_and_conditions_accepted"] == "0"
     return redirect_to new_app_install_path app_install: app_install_params, alert: 'You must accept the license terms and conditions to install this software.'
    end

    @app_install = AppInstall.new(app_install_params)
    @app_install.attach_icon_from_gallery if @app_install.icon.nil?

    if @app_install.build_app
      if @app_install.save
        redirect_to app_manager_path, notice: 'Application installation was successful.'
      else
        redirect_to installer_path, alert: 'Application installed but not configured. Edit the app in the App Manager to complete app configuration.'
      end
    else
      redirect_to installer_path, alert: 'Application installation was not successful.'
    end

  end

  def update_display_properties
    if @app_install.update_display_properties(app_install_params)
      redirect_to app_manager_path, notice: 'Display properties were successfully updated.'
    else
      render :edit_display_properties, alert: 'Display properties were not updated.'
    end
  end

  def update_network_properties
p ':update_network_properties'
p '@app_install'
p @app_install.inspect
    if @app_install.update_network_properties app_install_params
p @app_install.inspect
      redirect_to app_manager_path, notice: 'Network properties were successfully updated.'
    else
      render :edit_network_properties, alert: 'Network properties were not updated.'
    end
  end

  def update_runtime_properties
    if @app_install.update_runtime_properties app_install_params
      redirect_to app_manager_path, notice: 'Runtime properties were successfully updated.'
    else
      render :edit_runtime_properties, alert: 'Runtime properties were not updated.'
    end
  end

private

  def app_install_params
    params.require(:app_install).permit!
  end

  def set_app_install
    @app_install = AppInstall.find_or_create_by(engine_name: params[:id])
  end

end



