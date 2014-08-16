require 'EngineGallery.rb'
class GallerysController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @galleries = EngineGallery.list_local
  end
  
  def filter_blueprints(blueprint_type)
    
  end
  
  def install_blueprints  #FIXME need gallery id and blueprintid
    
  end
  
  def show  
    if  @galleries == nil
      @galleries = EngineGallery.list_local
    end
    @galleries.each do |gallery|
      p params[:id]
        if gallery.short_name == params[:id]
          @gallery = gallery         
          @blueprints= gallery.listBluePrints
        end   
     end
  end
  
 
end
