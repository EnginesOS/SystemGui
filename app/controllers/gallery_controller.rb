require 'EngineGallery.rb'
class GalleryController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @galleries = EngineGallery.list_local
  end
  
  def filter_blueprints(blueprinttype)
    
  end
  
  def show
    @gallery=EngineGallery.find(params[:short_name])
      @blueprints=@gallery.listBluePrints()
  end
  
 
end
