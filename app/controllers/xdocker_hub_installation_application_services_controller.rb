class DockerHubInstallationsController < ApplicationController

  before_action :authenticate_user!

  def new
    @docker_hub_installation_application_service = DockerHubInstallationApplicationService.load_new
  end

private

  def docker_hub_installation_params
    @software_install_params ||= params.require(:docker_hub_installation).permit!
  end


end

