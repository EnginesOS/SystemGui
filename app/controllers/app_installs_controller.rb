# require 'EngineGallery.rb'
# require "EnginesOSapi.rb"

class AppInstallsController < ApplicationController
  before_action :set_install, only: [:show, :update, :destroy] # , :edit
  before_action :authenticate_user!

  def installer
    @gallery_servers = GalleryInstall.all.map(&:gallery_server)
  end

  def new
    app_config = app_install_params
    gallery_server_name = app_config[:gallery_server_name]
    gallery_server_url = app_config[:gallery_server_url]
    blueprint_id = app_config[:blueprint_id]

    gallery = get_gallery gallery_server_name, gallery_server_url
    blueprint = gallery.get_blueprint blueprint_id

    app_name = blueprint['software']['name']

    app_config[:host_name] = app_name.gsub(/[^0-9A-Za-z]/, '').downcase
    app_config[:domain_name] = SystemConfig.default_domain
    app_config[:container_name] = app_config[:host_name]
    app_config[:display_name] = app_name
    app_config[:display_description] = blueprint['software']['description']
    app_config[:license_name] = blueprint['software']['license_name']
    app_config[:license_sourceurl] = blueprint['software']['license_sourceurl']

    @app_install = AppInstall.new(app_config)

    blueprint_environment_variables = blueprint['software']['environment_variables']
    if @app_install.app_install_env_variables.empty?
      blueprint_environment_variables.each do |ev|
        @app_install.app_install_env_variables.build(ev)
      end
    end
  end

  def edit
      @install = AppInstall.find_by_container_name(params[:id])

  end

  def create
    app_config = app_install_params

    if app_config["terms_and_conditions_accepted"] == "0"
     flash[:notice] = 'You must accept the license terms and conditions to install this software.'
     app_config = {app_install: app_config}
     return redirect_to new_app_install_path(app_config)
    else
      gallery_server_name = app_config[:gallery_server_name]
      gallery_server_url = app_config[:gallery_server_url]
      blueprint_id = app_config[:blueprint_id]

      gallery = get_gallery gallery_server_name, gallery_server_url
      blueprint = gallery.get_blueprint blueprint_id
      repository = gallery.get_repository blueprint_id

      app_install = AppInstall.new(app_config)

      if build_app(repository, app_build_params).instance_of?(ManagedEngine)
        if app_install.save
          redirect_to app_manager_path, notice: 'Application installation was successful.'
        else
          redirect_to installer_path, alert: 'Application installed but not configured. Edit the app in the App Manager to complete app configuration.'
        end
      else
        redirect_to installer_path, alert: 'Application installation was not successful.'
      end
    end

  end

  def update
    if @install.update(install_params)
      redirect_to app_manager_path, notice: 'Application details were successfully updated.'
    else
      render :edit, alert: 'Application details were not updated.'
    end
  end

  # DELETE /installs/1
  # DELETE /installs/1.json
  def destroy
    @install.destroy
    respond_to do |format|
      format.html { redirect_to installs_url, notice: 'Install was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_install
      @install = AppInstall.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_install_params
      params.require(:app_install).permit!
    end

    def app_build_params
      env_variables_attributes = params['app_install']['app_install_env_variables_attributes']
      env_variables = {}
      env_variables_attributes.each {|id,ev| env_variables[ev[:name].to_sym] = ev[:value]}      
      result = params.require(:app_install).permit(:container_name, :host_name, :domain_name)
      result[:env_variables] = env_variables
      return result
    end

    def get_gallery gallery_server_name, gallery_server_url
      EngineGallery.getGallery gallery_server_name, gallery_server_url
    end

    # def create_install_form_class environment_variables
    #   accessors = "attr_accessor :host_name, :host_domain, :terms_and_conditions_accepted, " + \
    #     ":display_name, :display_description, :terms_and_conditions_accepted, " + \
    #     ":gallery_server_name, :gallery_server_url, :blueprint_id"
    #   environment_variables.each do |ev|
    #     accessors = accessors + ", :environment_variable_" + ev["name"].underscore.gsub(/( )/, '_')
    #   end
    #   eval("class InstallForm; include ActiveModel::Model; " + accessors + "; end")
    # end    

end
