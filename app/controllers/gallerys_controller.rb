require 'EngineGallery.rb'
class GallerysController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @galleries = EngineGallery.list_local
  end
  
  def filter_blueprints(blueprint_type)
    
  end
  
  def show
    @gallery=EngineGallery.find(params[:short_name])
      @blueprints=@gallery.listBluePrints()
  end
  
 
end
