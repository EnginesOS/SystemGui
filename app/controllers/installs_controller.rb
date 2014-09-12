require 'EngineGallery.rb'
class InstallsController < ApplicationController
  before_action :set_install, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @installs = Install.all
  end

  def show
  end

  def new

p "$$$$$$$$$$$$$"
p params


    set_gallery
    set_blueprint

    @install = Install.new(install_params)

    @gallery_server_name = params[:install]["gallery_server_name"]
    @gallery_server_url = params[:install]["gallery_server_url"]
    @blueprint_id = params[:install]["blueprint_id"]

    @application_name = @blueprint["software"]["name"]
    @application_description = @blueprint["software"]["description"]
    @license_name = @blueprint["software"]["license_name"]
    @license_url = @blueprint["software"]["license_sourceurl"]
    # @memory = @blueprint["software"]["requiredmemory"]

  end

  def edit
  end

  def create

p "###########################"
p params

    if params["install"]["terms_and_conditions_accepted"] == "0"
p params["gallery_server_name"]
     return redirect_to new_install_path( \
       gallery_server_name: params["gallery_server_name"], \
       gallery_server_url: params["gallery_server_url"], \
       blueprint_id: params["blueprint_id"], \
       install: params["install"], \
       notice: 'You must accept the license terms and conditions to install this software.')
    end

    set_gallery
    set_blueprint
    set_repository

p "@@@@@@@@@@@@@@@@@@@@@@@@@@@"
p @repository
p params
p params[:install][:host_name]
p params[:install][:host_domain]


    @enginesOS_api.buildEngine(@repository, params[:install][:host_name], params[:install][:host_domain], "")
    #   redirect_to installer_path(notice: 'Installation was not successful.')
    # end

    params["blueprint"] = @blueprint.to_s

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
    

end
