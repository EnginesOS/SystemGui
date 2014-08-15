require 'EngineGallery.rb'
class GalleryController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @galleries=EngineGallery.listLocalGalleries()
  end
  
  def filter_blueprints(blueprinttype)
    
  end
  
  def show
    @gallery=EngineGallery.find(params[:id])
      @blueprints=@gallery.listBluePrints()
  end
  
 
end
