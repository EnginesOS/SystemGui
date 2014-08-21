require 'EngineGallery.rb'
class GallerysController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @galleries = EngineGallery.list_local
  end
  
  def filter_blueprints(blueprint_type)
    
  end
  
  def install_blueprint  #FIXME need gallery id and blueprintid
    @gallery = EngineGallery.getGallery(params[:id],params[:gallery_url])
      if @gallery !=nil
          @blueprint = @gallery.get_blueprint(params[:blueprint_id])
      else
        @error_mesg="Failed to load Gallery params[:id] params[:blueprints_url] " +  params[:id] + " " + params[:blueprints_url]           
      end
  end
  
  def show  
    if  @galleries == nil
      @galleries = EngineGallery.list_local
    end
    @galleries.each do |gallery|
     #p params[:id]
        if gallery.short_name == params[:id]
          @gallery = gallery         
          @blueprints= gallery.listBluePrints
        end   
     end
  end
  
 
end
