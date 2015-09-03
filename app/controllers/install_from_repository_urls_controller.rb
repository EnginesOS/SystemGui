class RepositoryUrlInstallationsController < ApplicationController

  before_action :authenticate_user!

  def new
    @repository_url_installation = RepositoryUrlInstallation.new()
  end

  def create
    @repository_url_installation = RepositoryUrlInstallation.new(repository_url_installation_params)
    if @repository_url_installation.valid?
      redirect_to new_application_installation_path(repository_url_installation_params)
    else
      render :new
    end
  end

private

  def repository_url_installation_params
    params.require(:repository_url_installation).permit(:repository_url)
  end

end
