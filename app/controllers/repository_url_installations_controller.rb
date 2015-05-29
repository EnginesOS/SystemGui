class RepositoryUrlInstallationsController < ApplicationController

  before_action :authenticate_user!

  def new
    @repository_url_installation = RepositoryUrlInstallation.new()
  end

  def create
    redirect_to new_application_installation_path(repository_url_installation_params) 
  end

private

  def repository_url_installation_params
    params.require(:repository_url_installation).permit(:repository_url)
  end

end
