class AppInstallsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_install, only: [
    :create,
    :installing,
    :edit_display_properties,
    :edit_runtime_properties,
    :edit_network_properties,
    :show_about_properties,
    :update_display_properties,
    :update_network_properties,
    :update_runtime_properties]
  before_action :load_properties_from_engine, only: [
    :edit_display_properties,
    :edit_network_properties,
    :edit_runtime_properties,
    :show_about_properties]

  def index
    @app_installs = AppInstall.all
  end

  def destroy_all_records
    AppInstall.delete_all
    redirect_to app_installs_path 
  end

  def new
    Maintenance.db_maintenance
    @app_install = AppInstall.new_from_gallery app_install_params
  end

  def create
    if app_install_params["terms_and_conditions_accepted"] == "0"
      redirect_to new_app_install_path(app_install: app_install_params), alert: "You must accept the license terms and conditions to install this software."
    elsif AppInstall.engine_name_not_unique(app_install_params)
      redirect_to new_app_install_path(app_install: app_install_params), alert: "Engine name must be unique."
    elsif AppInstall.host_name_not_unique(app_install_params)
      redirect_to new_app_install_path(app_install: app_install_params), alert: "Host name must be unique."
    else
      if @app_install.update(app_install_params)
        if @app_install.icon.exists? == false
          @app_install.attach_icon_using_icon_url_from_gallery
          @app_install.save
        end
        redirect_to installing_path(id: app_install_params[:engine_name], app_install: app_install_params)
      else
        redirect_to installer_path, alert: "Unable to initiate application installation for #{@app_install.engine_name}. Failed to save display properties to database."
      end
    end
  end

  def installing
    @app_install.update(app_install_params)
    build_response = @app_install.build_app
    if build_response.instance_of?(ManagedEngine)
      redirect_to app_manager_path, notice: "Application installation was successful for #{@app_install.engine_name}."
    elsif build_response.instance_of?(EnginesOSapiResult)
      redirect_to installer_path, alert: "Application installation was not successful for #{@app_install.engine_name}. " + build_response.result_mesg[0..250]
    else
      return render text: 'Unexpected response from build_app.'
    end
  end

  def update_display_properties
    if @app_install.update_display_properties(app_install_params)
      redirect_to app_manager_path, notice: "Display properties were successfully updated for #{@app_install.engine_name}."
    else
      redirect_to edit_app_install_display_properties_path(app_install: app_install_params), alert: "Display properties were not updated for #{@app_install.engine_name}."
    end
  end

  def update_network_properties
    if @app_install.update_network_properties app_install_params
      redirect_to app_manager_path, notice: "Network properties were successfully updated for #{@app_install.engine_name}."
    else
      redirect_to edit_app_install_network_properties_path(app_install: app_install_params), alert: "Network properties were not updated for #{@app_install.engine_name}."
    end
  end

  def update_runtime_properties
    if @app_install.update_runtime_properties app_install_params
      redirect_to app_manager_path, notice: "Runtime properties were successfully updated for #{@app_install.engine_name}."
    else
      render edit_app_install_runtime_properties_path(app_install: app_install_params), alert: "Runtime properties were not updated for #{@app_install.engine_name}."
    end
  end

private

  def app_install_params
    params.require(:app_install).permit!
  end

  def set_app_install
    @app_install = AppInstall.find_or_create_by(engine_name: params[:id])
  end

  def load_properties_from_engine
    @app_install.load_properties_from_engine
  end

end