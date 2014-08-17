
require "EnginesOSapi.rb"

class EnginesController < ApplicationController
  before_action :authenticate_user!
  

  
  def index
    @engines = @enginesOS_api.getManagedEngines()
      if @engines == nil
        @result =false
      else
        @result = true
      end
  end
  
  def show
    @engine = @enginesOS_api.loadManagedEngine(params[:id])
      if @engine == nil
        @result =false
      else
        @result =true
      end
  end
  
  def stop
    @engine = @enginesOS_api.loadManagedEngine(params[:id])
    @result = @engine.stop_container
    redirect_to engine_path(@engine.containerName)
  end
  
  def start
    @engine = @enginesOS_api.loadManagedEngine(params[:id])
    @result =  @engine.start_container
    redirect_to engine_path(@engine.containerName)
  end
  
  def pause
    @engine = @enginesOS_api.loadManagedEngine(params[:id])
    @result = @engine.pause_container
    redirect_to engine_path(@engine.containerName)
  end
  
  def unpause
    @engine = @enginesOS_api.loadManagedEngine(params[:id])
     @result = @engine.unpause_container
    redirect_to engine_path(@engine.containerName)
   end
   
  def destroy_engine
    @engine = @enginesOS_api.loadManagedEngine(params[:id])
    @result =@engine.destroy_container
    redirect_to engine_path(@engine.containerName)
  end 
  
  def deleteimage
    @engine = @enginesOS_api.loadManagedEngine(params[:id])
      if (@engine)      
        @result =@engine.delete_image        
        redirect_to engine_path(@engine.containerName)
      end #FIX ME Need to go some
  end 
  
  def restart
    @engine = @enginesOS_api.loadManagedEngine(params[:id])
    @result = @engine.restart_container
    redirect_to engine_path(@engine.containerName)
  end
  
  def create_engine
    @engine = @enginesOS_api.loadManagedEngine(params[:id])
        @result = @engine.create_container
        redirect_to engine_path(@engine.containerName)
  end

  def monitor
    @engine = @enginesOS_api.loadManagedEngine(params[:id])
            @result = @engine.monitor_site
            redirect_to engine_path(@engine.containerName)
  end
  
  def demonitor
    @engine = @enginesOS_api.loadManagedEngine(params[:id])
            @result = @engine.demonitor_site
            redirect_to engine_path(@engine.containerName)
  end
  
  def register_site
       @engine = @enginesOS_api.loadManagedEngine(params[:id])
                @result = @engine.register_site
                redirect_to engine_path(@engine.containerName)
  end
  
  def deregister_site
       @engine = @enginesOS_api.loadManagedEngine(params[:id])
                @result = @engine.deregister_site
                redirect_to engine_path(@engine.containerName)
  end
  
  def edit
       @engine = @enginesOS_api.loadManagedEngine(params[:id])
         #FIXME still to do
      #only on nocontainer but with image 
      #will trigger a create
  end
  
end
