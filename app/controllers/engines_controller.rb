
require "EnginesOSapi.rb"

class EnginesController < ApplicationController
  before_action :authenticate_user!
  

  
  def index
    @result =false
    @engines = enginesOS_api.getManagedEngines()
      if @engines != nil
        @result = true      
      end
      
  end
  
  def show
    @result =false
    @engine = @enginesOS_api.loadManagedEngine(params[:id])
      if @engine != nil
        @result = true
      end
  end
  
  def stop   
    @result = @enginesOS_api.stopEngine @engine.containerName
    redirect_to engine_path(@engine.containerName)
  end
  
  def start   
    @result = @enginesOS_api.startEngine @engine.containerName
    redirect_to engine_path(@engine.containerName)
  end
  
  def pause
    @result = @enginesOS_api.pauseEngine @engine.containerName
    redirect_to engine_path(@engine.containerName)
  end
  
  def unpause
    @result = @enginesOS_api.unpauseEngine @engine.containerName
    redirect_to engine_path(@engine.containerName)
   end
   
  def destroy_engine
    @result = @enginesOS_api.destroyEngine @engine.containerName
    redirect_to engines_path
  end 
  
  def deleteimage
    @result = @enginesOS_api.deleteEngine @engine.containerName
        redirect_to engines_path

  end 
  
  def restart
    @result = @enginesOS_api.restartEngine @engine.containerName
    redirect_to engine_path(@engine.containerName)
  end
  
  def create_engine
    @result = @enginesOS_api.createEngine @engine.containerName
        redirect_to engine_path(@engine.containerName)
  end

  def monitor
    @result = @enginesOS_api.monitorEngine @engine.containerName
            redirect_to engine_path(@engine.containerName)
  end
  
  def demonitor
    @result = @enginesOS_api.unmonitorEngine @engine.containerName
            redirect_to engine_path(@engine.containerName)
  end
  
  def register_site
    @result = @enginesOS_api.registerEngineWebSite @engine.containerName
                redirect_to engine_path(@engine.containerName)
  end
  
  def deregister_site
    @result = @enginesOS_api.unregisterEngineWebSite @engine.containerName
    
                redirect_to engine_path(@engine.containerName)
  end
  
  def edit
       @engine = @enginesOS_api.loadManagedEngine(params[:id])
         #FIXME still to do
      #only on nocontainer but with image 
      #will trigger a create
  end
  
end
