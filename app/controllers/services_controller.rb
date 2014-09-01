require "EnginesOSapi.rb"

class ServicesController < ApplicationController
  before_action :authenticate_user!
  
  def stop
    @result = @enginesOS_api.stopService params[:id]
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end

  def start
    @result = @enginesOS_api.startService params[:id]
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
     
  def pause
    @result = @enginesOS_api.pauseService params[:id]
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
    
  def unpause
    @result = @enginesOS_api.unpauseService params[:id]
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
    
  def register_site
    @result = @enginesOS_api.registerServiceWebSite params[:id]
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
   
  def deregister_site
    @result = @enginesOS_api.deregisterServiceWebSite params[:id]
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end

  def register_dns
    @result = @enginesOS_api.registerServiceDNS params[:id]
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
   
  def deregister_dns
    @result = @enginesOS_api.deregisterServiceDNS params[:id]
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end

  def create_service     
    @result = @enginesOS_api.createService params[:id]
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end
    
  def recreate 
    @result = @enginesOS_api.recreateService params[:id]
    @notice = @result.result_mesg
    redirect_to control_panel_path, notice: @notice
  end

end
