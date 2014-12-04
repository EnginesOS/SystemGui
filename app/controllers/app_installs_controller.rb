class AppInstallsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_install, only: [
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

  # def load_runtime_properties
  #   @app_install.load_runtime_properties
  # end

  # def load_about_properties
  #   @app_install.load_about_properties
  # end

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
      @app_install = AppInstall.new(app_install_params)
      @app_install.attach_icon_using_icon_url_from_gallery #if !@app_install.icon.exists?

      build_response = @app_install.build_app

      if build_response.instance_of?(ManagedEngine)
        if @app_install.save
          redirect_to app_manager_path, notice: "Application installation was successful for #{@app_install.engine_name}."
        else
          redirect_to installer_path, alert: "Application installed but not configured for #{@app_install.engine_name}. Edit the app in the App Manager to complete app configuration."
        end
      else
        redirect_to installer_path, alert: "Application installation was not successful for #{@app_install.engine_name}." + build_response.mesg
      end
    end
  end

  def update_display_properties


p ':update_display_properties'
# p @app_install.icon.exists?

    # @app_install.attach_icon_using_icon_url_in_engine if !@app_install.icon.exists?

# p @app_install.icon

    if @app_install.update_display_properties(app_install_params)
      redirect_to app_manager_path, notice: "Display properties were successfully updated for #{@app_install.engine_name}."
    else
      render :edit_display_properties, alert: "Display properties were not updated for #{@app_install.engine_name}."
    end
  end

  def update_network_properties
p ':update_network_properties'
p '@app_install'
p @app_install.inspect
    if @app_install.update_network_properties app_install_params
p @app_install.inspect
      redirect_to app_manager_path, notice: "Network properties were successfully updated for #{@app_install.engine_name}."
    else
      render :edit_network_properties, alert: "Network properties were not updated for #{@app_install.engine_name}."
    end
  end

  def update_runtime_properties
    if @app_install.update_runtime_properties app_install_params
      redirect_to app_manager_path, notice: "Runtime properties were successfully updated for #{@app_install.engine_name}."
    else
      render :edit_runtime_properties, alert: "Runtime properties were not updated for #{@app_install.engine_name}."
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



