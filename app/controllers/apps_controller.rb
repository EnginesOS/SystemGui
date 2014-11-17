# require "EnginesOSapi.rb"

class AppsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_app, only: [:advanced_detail]

  def advanced_detail
    render partial: "advanced_detail", locals: {app: load_app(params[:id])}
  end

  def stop
    redirect_to app_manager_path, notice: stop_app(params[:id])
  end
  
  def start   
    redirect_to app_manager_path, notice: start_app(params[:id])
  end
  
  def pause
    redirect_to app_manager_path, notice: pause_app(params[:id])
  end
  
  def unpause
    redirect_to app_manager_path, notice: unpause_app(params[:id])
   end
   
  def destroy_container
    redirect_to app_manager_path, notice: destroy_container_app(params[:id])
  end 
  
  def delete_image
    redirect_to app_manager_path, notice: delete_image_app(params[:id])
  end 
  
  def restart #is this method called in app manager?
    redirect_to app_manager_path, notice: restart_app(params[:id])
  end
  
  def create_container
    redirect_to app_manager_path, notice: create_container_app(params[:id])
  end

  def recreate
    redirect_to app_manager_path, notice: recreate_app(params[:id])
  end

  def monitor
    redirect_to app_manager_path, notice: monitor_app(params[:id])
  end
  
  def demonitor
    redirect_to app_manager_path, notice: demonitor_app(params[:id])
  end
  
  def register_website
    redirect_to app_manager_path, notice: register_website_app(params[:id])
  end
  
  def deregister_website
    redirect_to app_manager_path, notice: deregister_website_app(params[:id])
  end
  
  def register_dns
    redirect_to app_manager_path, notice: register_dns_app(params[:id])
  end
  
  def deregister_dns
    redirect_to app_manager_path, notice: deregister_dns_app(params[:id])
  end

# private

#     def set_app
#       @app = load_app(params[:id])
#     end
  
end
