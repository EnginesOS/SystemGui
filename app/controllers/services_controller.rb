

require "EnginesOSapi.rb"

class ServicesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @services = enginesOS_api.getManagedServices()
           if @services == nil
             @result =false
           else
             @result = true
           end
  end
  def show
      @service = enginesOS_api.loadManagedService(params[:id])
        if @service == nil
          @result =false
        else
          @result =true
        end
    end
    
    def stop
      @service = enginesOS_api.loadManagedService(params[:id])
          @result = @enginesOS_api.stopService params[:id]
          redirect_to service_path(params[:id])
    end
   def start
       @service = enginesOS_api.loadManagedService(params[:id])
       @result = @enginesOS_api.startService params[:id]
       redirect_to service_path(params[:id])
   end
     
    def pause
      @service = enginesOS_api.loadManagedService(params[:id])
      @result = @enginesOS_api.pauseService params[:id]
      redirect_to service_path(params[:id])
    end
    
    def unpause
      @service = enginesOS_api.loadManagedService(params[:id])
      @result = @enginesOS_api.unpauseService params[:id]
       redirect_to service_path(params[:id])
    end
    
  def register_site
        @service = enginesOS_api.loadManagedService(params[:id])
        @result = @enginesOS_api.registerServiceWebSite params[:id]
        redirect_to service_path(params[:id])
   end
   
   def deregister_site
     @service = enginesOS_api.loadManagedService(params[:id])
     @result = @enginesOS_api.deregisterServiceWebSite params[:id]
     redirect_to service_path(params[:id])
   end
   
  def create_service
    @service = enginesOS_api.loadManagedService(params[:id])      
    @result = @enginesOS_api.createService params[:id]
    redirect_to service_path(params[:id])
  end

    
    def recreate 
      @service = enginesOS_api.loadManagedService(params[:id])
      @result = @enginesOS_api.recreateService params[:id]
      redirect_to service_path(params[:id]) 
    end
end
