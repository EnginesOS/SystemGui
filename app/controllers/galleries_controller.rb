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

  def add
    @gallery = Gallery.new
    @gallery_servers = EngineGallery.list_local
  end

  def create

    p params
    p params
    gallery_server_short_name = params["gallery_server_short_name"]
    gallery_server_domain = params["gallery_server_domain"]
    gallery_server_url = gallery_server_short_name + "." + gallery_server_domain
    @gallery = Gallery.new(url: gallery_server_url)
    @gallery.save
    redirect_to galleries_path
  end

  def remove
    @gallery = Gallery.find(params[:id])
    @gallery.destroy
    redirect_to galleries_path
  end
  
  # def filter_blueprints(blueprint_type)
  # end
  
  def install_blueprint  
    gallery = EngineGallery.getGallery(params[:id],params[:gallery_url])
      if gallery !=nil

          @blueprint = gallery.get_blueprint(params[:blueprint_id])
            if @blueprint != nil
              @gallery = gallery.get_repository(params[:blueprint_id])
            else   
              @error_mesg="Failed to load blueprint " + params[:blueprint_id] + " from " + params[:gallery_url] + " via " + gallery.blueprints_url
            end
           
      else
        @error_mesg="Failed to load Gallery params[:id] params[:gallery_url] params[:blueprint_id] " +  params[:id] + " " + params[:gallery_url] + " " +  params[:blueprint_id]           
        redirect_to gallery_path(params[:gallery_url]), notice: @error_mesg
      end
  end

  def install_from_blueprint
    engine = @enginesOS_api.buildEngine(params[:blueprints_gallery],params[:host_name],params[:domain_name],"")
    redirect_to engine_path(engine.containerName)
  end



end
