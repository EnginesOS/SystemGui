class AppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_handler

  def advanced_detail
    render partial: "advanced_detail"
  end

  def stop
    result = @app.stop
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end
  
  def start   
    result = @app.start
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end
  
  def pause
    result = @app.pause
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end
  
  def unpause
    result = @app.unpause
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
   end
   
  def destroy_container
    result = @app.destroy_container
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end 
  
  def delete_image
    result = @app.delete_image
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end 
  
  def restart
    result = @app.restart
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end
  
  def create_container
    result = @app.create_container
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end

  def recreate
    result = @app.recreate
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end

  def monitor
    result = @app.monitor
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end
  
  def demonitor
    result = @app.demonitor
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end
  
  def register_website
    result = @app.register_website
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end
  
  def deregister_website
    result = @app.deregister_website
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end
  
  def register_dns
    result = @app.register_dns
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end
  
  def deregister_dns
    result = @app.deregister_dns
      if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
      end    
    redirect_to app_manager_path 
  end

private

  def set_app_handler
    @app = AppHandler.new params[:id]
  end
  
end
