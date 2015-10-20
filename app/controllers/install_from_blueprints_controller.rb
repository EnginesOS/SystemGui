class InstallFromBlueprintsController < ApplicationController

  def new
    @install_from_blueprint = InstallFromBlueprint.new(install_from_blueprint_params)
    @install_from_blueprint.build_new
    redirect_to installer_path,
      alert: "Unable to install #{install_from_blueprint_params[:software_title]}. Can't load from repository #{params[:repository_url]}." \
        if @install_from_blueprint.blueprint == false
  end

  def create
    @install_from_blueprint = InstallFromBlueprint.new(install_from_blueprint_params)
    # render text: @install_from_blueprint.engine_build_params
    if @install_from_blueprint.install
      redirect_to preparing_installation_application_installation_path(application_name: @install_from_blueprint.application.container_name)
    else
      render :new
    end
  end

private

  def install_from_blueprint_params
    params.require(:install_from_blueprint).permit!
  end

end
