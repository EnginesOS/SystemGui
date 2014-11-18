# require "EnginesOSapi.rb"

class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service, only: [:advanced_detail]

  def advanced_detail
    render partial: "advanced_detail"
  end
  
  def create_container
    redirect_to app_manager_path, notice: create_container_service(params[:id])
  end

  def stop
    redirect_to app_manager_path, notice: stop_service(params[:id])
  end

  def start
    redirect_to app_manager_path, notice: start_service(params[:id])
  end

  def pause
    redirect_to app_manager_path, notice: pause_service(params[:id])
  end

  def unpause
    redirect_to app_manager_path, notice: unpause_service(params[:id])
  end

  def register_website
    redirect_to app_manager_path, notice: register_website_service(params[:id])
  end

  def deregister_website
    redirect_to app_manager_path, notice: deregister_website_service(params[:id])
  end

  def register_dns
    redirect_to app_manager_path, notice: register_dns_service(params[:id])
  end

  def deregister_dns
    redirect_to app_manager_path, notice: deregister_dns_service(params[:id])
  end

private

  def set_service
   @service = $enginesOS_api.getManagedService(params[:id])
  end

end

