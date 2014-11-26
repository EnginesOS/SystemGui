class AppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_handler

  def advanced_detail
    render partial: "advanced_detail"
  end

  def stop
    redirect_to app_manager_path, notice: @app.stop
  end
  
  def start   
    redirect_to app_manager_path, notice: @app.start
  end
  
  def pause
    redirect_to app_manager_path, notice: @app.pause
  end
  
  def unpause
    redirect_to app_manager_path, notice: @app.unpause
   end
   
  def destroy_container
    redirect_to app_manager_path, notice: @app.destroy_container
  end 
  
  def delete_image
    redirect_to app_manager_path, notice: @app.delete_image
  end 
  
  def restart
    redirect_to app_manager_path, notice: @app.restart
  end
  
  def create_container
    redirect_to app_manager_path, notice: @app.create_container
  end

  def recreate
    redirect_to app_manager_path, notice: @app.recreate
  end

  def monitor
    redirect_to app_manager_path, notice: @app.monitor
  end
  
  def demonitor
    redirect_to app_manager_path, notice: @app.demonitor
  end
  
  def register_website
    redirect_to app_manager_path, notice: @app.register_website
  end
  
  def deregister_website
    redirect_to app_manager_path, notice: @app.deregister_website
  end
  
  def register_dns
    redirect_to app_manager_path, notice: @app.register_dns
  end
  
  def deregister_dns
    redirect_to app_manager_path, notice: @app.deregister_dns
  end

private

  def set_app_handler
    @app = AppHandler.new params[:id]
  end
  
end
