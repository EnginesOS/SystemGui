require 'EngineGallery.rb'
class GallerysController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @galleries = EngineGallery.list_local
  end
  
  def filter_blueprints(blueprint_type)
    
  end
  
  def install_blueprint  
    @gallery = EngineGallery.getGallery(params[:id],params[:gallery_url])
      if @gallery !=nil
          @blueprint = @gallery.get_blueprint(params[:blueprint_id])
            if @blueprint != nil            
              @blueprint_id=params[:blueprint_id]
            else
              @error_mesg="Failed to load blueprint " + params[:blueprint_id] + " from " + params[:gallery_url] + " via " + @gallery.blueprints_url
            end
      else
        @error_mesg="Failed to load Gallery params[:id] params[:gallery_url] params[:blueprint_id] " +  params[:id] + " " + params[:blueprint_id] + " " +  params[:gallery_url]           
      end
  end
  def install_from_blueprint
    
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
