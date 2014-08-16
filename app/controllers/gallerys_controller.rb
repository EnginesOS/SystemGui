require 'EngineGallery.rb'
class GallerysController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @galleries = EngineGallery.list_local
  end
  
  def filter_blueprints(blueprint_type)
    
  end
  
  def show
    @galleries = EngineGallery.list_local
    if @galleries
      @gallery=@galleries[0]
      @blueprints=@gallery.listBluePrints()
    else  
        @gallery=nil
    end
  end
  
 
end
