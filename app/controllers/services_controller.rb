# require "EnginesOSapi.rb"

class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service

  def advanced_detail
    render partial: "advanced_detail"
  end
  
  def create_container
    redirect_to app_manager_path, notice: @service.create_container.result_mesg
  end

  def stop
    redirect_to app_manager_path, notice: @service.stop.result_mesg
  end

  def start
    redirect_to app_manager_path, notice: @service.start.result_mesg
  end

  def pause
    redirect_to app_manager_path, notice: @service.pause.result_mesg
  end

  def unpause
    redirect_to app_manager_path, notice: @service.unpause.result_mesg
  end

  def register_website
    redirect_to app_manager_path, notice: @service.register_website.result_mesg
  end

  def deregister_website
    redirect_to app_manager_path, notice: @service.deregister_website.result_mesg
  end

  def register_dns
    redirect_to app_manager_path, notice: @service.register_dns.result_mesg
  end

  def deregister_dns
    redirect_to app_manager_path, notice: @service.deregister_dns.result_mesg
  end

private

  def set_service
   @service = ServiceHandler.new params[:id]
  end

end

