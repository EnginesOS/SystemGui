require 'EngineGallery.rb'
class GalleriesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @galleries = EngineGallery.list_local
  end
  
  def filter_blueprints(blueprint_type)
    
  end
  
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

  def show
    @galleries = EngineGallery.list_local
    @galleries.each do |gallery|
      if gallery.short_name == params[:short_name]
        @gallery = gallery
        @blueprints = gallery.listBluePrints
      end
    end
    # render :debug
  end

end
