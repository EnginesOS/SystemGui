class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service

  def advanced_detail
    render partial: "advanced_detail"
  end
  
  def create_container
    @result = @service.create_container
    set_flash_messages_and_redirect
  end

  def recreate
    @result = @service.recreate
    set_flash_messages_and_redirect
  end

  def stop
    @result = @service.stop
    set_flash_messages_and_redirect
  end

  def start
    @result = @service.start
    set_flash_messages_and_redirect
  end

  def pause
    @result = @service.pause
    set_flash_messages_and_redirect
  end

  def unpause
    @result = @service.unpause
    set_flash_messages_and_redirect
  end

  def register_website
    @result = @service.register_website
    set_flash_messages_and_redirect
  end

  def deregister_website
    @result = @service.deregister_website
    set_flash_messages_and_redirect
  end

  def register_dns
    @result = @service.register_dns
    set_flash_messages_and_redirect
  end

  def deregister_dns
    @result = @service.deregister_dns
    set_flash_messages_and_redirect
  end

private

  def set_service
   @service = ServiceHandler.new params[:id]
  end

  def set_flash_messages_and_redirect
    if @result.was_success == true
      flash[:notice] = @result.result_mesg[0..250]
    else
      flash[:error] = @result.result_mesg[0..250]
    end
    redirect_to app_manager_path
  end

end

