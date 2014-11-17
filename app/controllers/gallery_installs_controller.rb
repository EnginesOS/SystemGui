# require 'EngineGallery.rb'
class GalleryInstallsController < ApplicationController
  before_action :authenticate_user!

  def index
    @galleries = GalleryInstall.all
    @unadded_gallery_servers = GalleryInstall.get_unadded_gallery_servers
  end

  def create
    @gallery = GalleryInstall.new(
      url: params["gallery_server_url"],
      name: params["gallery_server_name"])
    @gallery.save
    redirect_to gallery_installs_path
  end

  def destroy
    @gallery = GalleryInstall.find(params[:id])
    @gallery.destroy
    redirect_to gallery_installs_path
  end

end
