class InstallFromDockerHubsController < ApplicationController

  def new
    @install_from_docker_hub = InstallFromDockerHub.build_new
  end
  
  def create
    @install_from_docker_hub = InstallFromDockerHub.new(install_from_docker_hub_params)
    if @install_from_docker_hub.ready_to_configure?
      redirect_to new_install_from_docker_hub_configuration_path(@install_from_docker_hub.new_configuration_params)
    else
      render :new
    end
  end
    
private

  def install_from_docker_hub_params
    @software_install_params ||= params.require(:install_from_docker_hub).permit!
  end

end

