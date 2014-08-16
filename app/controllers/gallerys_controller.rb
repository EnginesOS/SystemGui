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
    
    @gallery=  EngineGallery.find(params[:short_name],@galleries)
   if @gallery != nil   
      @blueprints=@gallery[0].listBluePrints()    
    end
  end
  
 
end
