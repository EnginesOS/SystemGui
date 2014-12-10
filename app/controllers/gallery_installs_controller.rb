class GalleryInstallsController < ApplicationController
  before_action :authenticate_user!

  def index
    @galleries = GalleryInstall.all.sort_by{|d| d.name}
    # @unadded_gallery_servers = GalleryInstall.get_unadded_gallery_servers
  end

  def new
    @gallery = GalleryInstall.new
  end

  def edit
    @gallery = GalleryInstall.find(params[:id])
  end

  def update
    @gallery = GalleryInstall.find(params[:id])
    @gallery.update(gallery_install_params)
    redirect_to gallery_installs_path
  end

  def create
    @gallery = GalleryInstall.new(gallery_install_params)
    @gallery.save
    redirect_to gallery_installs_path
  end

  def destroy
    @gallery = GalleryInstall.find(params[:id])
    @gallery.destroy
    redirect_to gallery_installs_path
  end

private

  def gallery_install_params
    params.require(:gallery_install).permit!
  end

end
