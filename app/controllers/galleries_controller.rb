require 'EngineGallery.rb'
class GalleriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @galleries = Gallery.all

    @added_gallery_servers = []
    @galleries.each do |gallery|
      @added_gallery_servers << gallery.gallery_server
    end
    @added_gallery_server_short_names = @added_gallery_servers.map(&:short_name)
    @all_gallery_servers = EngineGallery.list_local
    @all_gallery_server_short_names = @all_gallery_servers.map(&:short_name)
    @unadded_gallery_server_short_names = @all_gallery_server_short_names - @added_gallery_server_short_names

    @unadded_gallery_servers = []
    @unadded_gallery_server_short_names.each do |unadded_gallery_server_short_name|
      @all_gallery_servers.each do |gallery_server|
        if gallery_server.short_name == unadded_gallery_server_short_name
          @unadded_gallery_servers << gallery_server
        end
      end
    end
  end

  # def new
  #   @gallery = Gallery.new
  #   @gallery_servers = EngineGallery.list_local
  # end

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
