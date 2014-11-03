require 'EngineGallery.rb'
require "EnginesOSapi.rb"

class InstallsController < ApplicationController
  before_action :set_install, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @installs = Install.all
    render text: $enginesOS_api.getManagedEngines
  end

  def show
  end

  def new
    set_gallery
    set_blueprint

    @gallery_server_name = params[:install]["gallery_server_name"]
    @gallery_server_url = params[:install]["gallery_server_url"]
    @blueprint_id = params[:install]["blueprint_id"]

    @application_name = @blueprint["software"]["name"]
    @application_description = @blueprint["software"]["description"]

    @blueprint_environment_variables = @blueprint["software"]["environment_variables"]
    # @blueprint_environment_variables.each do |ev|
    #   @install.env_variables.build
    # end
    # @install.user_environment_variables = @blueprint["software"]["environment_variables"]

    create_install_form_class @blueprint_environment_variables
    @install_form = InstallForm.new(install_params)



    @license_name = @blueprint["software"]["license_name"]
    @license_url = @blueprint["software"]["license_sourceurl"]
  end

  def edit
  end

  def create
    params[:install] = params[:installs_controller_install_form]
    params.delete(:installs_controller_install_form)
    # render text: params.inspect

    if params["install"]["terms_and_conditions_accepted"] == "0"
     flash[:notice] = 'You must accept the license terms and conditions to install this software.'
     return redirect_to new_install_path( \
       gallery_server_name: params["gallery_server_name"], \
       gallery_server_url: params["gallery_server_url"], \
       blueprint_id: params["blueprint_id"], \
       install: params["install"])
    end

    set_gallery
    set_blueprint
    set_repository
p :wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
    p params
p :wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
    $enginesOS_api.buildEngine(@repository, params[:install][:host_name], params[:install][:host_domain], params)
    #james will add a result to buildEngines call
    @install = Install.new(install_params)

    if @install.save
      redirect_to root_path(notice: 'Installation was successful.')
    else
      redirect_to installer_path(notice: 'Installation was not successful.')
    end
  end

  def update
    respond_to do |format|
      if @install.update(install_params)
        format.html { redirect_to @install, notice: 'Install was successfully updated.' }
        format.json { render :show, status: :ok, location: @install }
      else
        format.html { render :edit }
        format.json { render json: @install.errors, status: :unprocessable_entity }
      end
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
      @install = Install.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def install_params
      params.require(:install).permit( \
        :display_name, \
        :display_description, \
        :blueprint, \
        :terms_and_conditions_accepted, \
        :gallery_server_name, \
        :gallery_server_url, \
        :blueprint_id )
    end

    def set_gallery
      @gallery = EngineGallery.getGallery(params[:install][:gallery_server_name],params[:install][:gallery_server_url])
      # if @gallery == nil
      #   redirect_to installer_path, notice: "Failed to load gallery."
      # end
    end

    def set_blueprint
      @blueprint = @gallery.get_blueprint(params[:install][:blueprint_id])
      # if @blueprint == nil
      #   redirect_to installer_path, notice: "Failed to load blueprint."
      # end
    end

    def set_repository
      @repository = @gallery.get_repository(params[:install][:blueprint_id])
      # if @repository == nil
      #   redirect_to installer_path, notice: "Failed to load repository."
      # end
    end

    def create_install_form_class environment_variables
      accessors = "attr_accessor :host_name, :host_domain, :terms_and_conditions_accepted, " + \
        ":display_name, :display_description, :terms_and_conditions_accepted, " + \
        ":gallery_server_name, :gallery_server_url, :blueprint_id"
      environment_variables.each do |ev|
        accessors = accessors + ", :environment_variable_" + ev["name"].underscore.gsub(/( )/, '_')
      end
      eval("class InstallForm; include ActiveModel::Model; " + accessors + "; end")
    end    

end
