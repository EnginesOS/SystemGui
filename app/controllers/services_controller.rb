class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service

  def advanced_detail
    render partial: "advanced_detail"
  end
  
  def create_container
    result = @service.create_container.result_mesg
    if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
    end    
    redirect_to app_manager_path
  end

  def stop
    result = @service.stop.result_mesg
    if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
    end    
    redirect_to app_manager_path
  end

  def start
    result = @service.start.result_mesg
    if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
    end    
    redirect_to app_manager_path
  end

  def pause
    result = @service.pause.result_mesg
    if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
    end    
    redirect_to app_manager_path
  end

  def unpause
    result = @service.unpause.result_mesg
    if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
    end    
    redirect_to app_manager_path
  end

  def register_website
    result = @service.register_website.result_mesg
    if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
    end    
    redirect_to app_manager_path
  end

  def deregister_website
    result = @service.deregister_website.result_mesg
    if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
    end    
    redirect_to app_manager_path
  end

  def register_dns
    result = @service.register_dns.result_mesg
    if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
    end    
    redirect_to app_manager_path
  end

  def deregister_dns
    result = @service.deregister_dns.result_mesg
    if result.was_success == true
        flash[:notice] = result.result_mesg
      else
        flash[:error] = result.result_mesg
    end    
    redirect_to app_manager_path
  end

private

  def set_service
   @service = ServiceHandler.new params[:id]
  end

end

