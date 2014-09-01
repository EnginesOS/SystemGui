require "EnginesOSapi.rb"

class EnginesController < ApplicationController
  before_action :authenticate_user!
  
  def stop   
    @result = @enginesOS_api.stopEngine(params[:id])
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
  
  def start   
    @result = @enginesOS_api.startEngine(params[:id])
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
  
  def pause
    @result = @enginesOS_api.pauseEngine(params[:id])
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
  
  def unpause
    @result = @enginesOS_api.unpauseEngine(params[:id])
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
   end
   
  def destroy_engine
    @result = @enginesOS_api.destroyEngine(params[:id])
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end 
  
  def deleteimage
    @result = @enginesOS_api.deleteEngineImage(params[:id])
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end 
  
  def restart
    @result = @enginesOS_api.restartEngine(params[:id])
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
  
  def create_engine
    @result = @enginesOS_api.createEngine(params[:id])
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end

  def monitor
    @result = @enginesOS_api.monitorEngine(params[:id])
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
  
  def demonitor
    @result = @enginesOS_api.demonitorEngine(params[:id])
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
  
  def register_site
    @result = @enginesOS_api.registerEngineWebSite(params[:id])
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
  
  def deregister_site
    @result = @enginesOS_api.deregisterEngineWebSite(params[:id])    
     @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
  
  def register_dns
    @result = @enginesOS_api.registerEngineDNS(params[:id])
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
  
  def deregister_dns
    @result = @enginesOS_api.deregisterEngineDNS(params[:id])    
     @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
   
  def edit
       @engine = @enginesOS_api.loadManagedEngine(params[:id])
         #FIXME still to do
      #only on nocontainer but with image 
      #will trigger a create
  end
  
end
