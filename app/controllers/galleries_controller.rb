require 'EngineGallery.rb'
class GalleriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @galleries = Gallery.all
  end

  def new
    @gallery = Gallery.new
    @gallery_servers = EngineGallery.list_local
  end

  def create
    gallery_server_short_name = params["gallery_server_short_name"]
    gallery_server_domain = params["gallery_server_domain"]
    gallery_server_url = gallery_server_short_name + "." + gallery_server_domain
    @gallery = Gallery.new(url: gallery_server_url)
    @gallery.save
    redirect_to galleries_path
  end

  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy
    redirect_to galleries_path
  end

end
