class InstallFromDockerHubConfigurationsController < ApplicationController

  def new
    @install_from_docker_hub = InstallFromDockerHub.build_configuration(install_from_docker_hub_params)
  end

  def create
    @install_from_docker_hub = InstallFromDockerHub.new(install_from_docker_hub_params)
    if @install_from_docker_hub.ready_to_install?
      install_software
    else
      render :new
    end
  end

  def install_software
    Thread.new do
      @install_from_docker_hub.install
    end
    redirect_to preparing_installation_application_installation_path(
      application_name: @install_from_docker_hub.application.container_name
      )
  end

private

  def install_from_docker_hub_params #_with_configuration_attributes_as_json
    params.require(:install_from_docker_hub).permit!
  end

end
