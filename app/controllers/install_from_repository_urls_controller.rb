class InstallFromRepositoryUrlsController < ApplicationController

  before_action :authenticate_user!

  def new
    @install_from_repository_url = InstallFromRepositoryUrl.new()
  end

  def create
    @install_from_repository_url = InstallFromRepositoryUrl.new(install_from_repository_url_params)
    if @install_from_repository_url.valid?
      redirect_to new_install_from_blueprint_path(install_from_blueprint_params)
    else
      render :new
    end
  end

private

  def install_from_blueprint_params
    {install_from_blueprint: {repository_url: install_from_repository_url_params[:repository_url]}}
  end

  def install_from_repository_url_params
    params.require(:install_from_repository_url).permit(:repository_url)
  end

end
