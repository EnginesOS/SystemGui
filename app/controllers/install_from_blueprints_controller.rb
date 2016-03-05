class InstallFromBlueprintsController < ApplicationController

  def new
    @install_from_blueprint = InstallFromBlueprint.new(install_from_blueprint_params)
    @install_from_blueprint.build_new
    if @install_from_blueprint.blueprint == false
      redirect_to installer_path(search: params[:search], page: params[:page], tags: params[:tags]),
        alert: "Unable to install #{install_from_blueprint_params[:software_title]}. Can't load from repository #{params[:repository_url]}."
    elsif @install_from_blueprint.application_services_to_start.present?
      redirect_to installer_path(search: params[:search], page: params[:page], tags: params[:tags]),
        alert: "Please start the following services before installing #{@install_from_blueprint.title}: #{@install_from_blueprint.application_services_to_start.to_sentence}."
    end
  end

  def create
    @install_from_blueprint = InstallFromBlueprint.new(install_from_blueprint_params)
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
