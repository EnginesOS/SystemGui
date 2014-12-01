class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service
  # after_action :set_flash_messages_and_redirect, except: [:advanced_detail]

  def advanced_detail
    render partial: "advanced_detail"
  end
  
  def create_container
    @result = @service.create_container.result_mesg
    set_flash_messages_and_redirect
  end

  def recreate
    @result = @service.recreate
    set_flash_messages_and_redirect
  end

  def stop
    @result = @service.stop.result_mesg
    set_flash_messages_and_redirect
  end

  def start
    @result = @service.start.result_mesg
    set_flash_messages_and_redirect
  end

  def pause
    @result = @service.pause.result_mesg
    set_flash_messages_and_redirect
  end

  def unpause
    @result = @service.unpause.result_mesg
    set_flash_messages_and_redirect
  end

  def register_website
    @result = @service.register_website.result_mesg
    set_flash_messages_and_redirect
  end

  def deregister_website
    @result = @service.deregister_website.result_mesg
    set_flash_messages_and_redirect
  end

  def register_dns
    @result = @service.register_dns.result_mesg
    set_flash_messages_and_redirect
  end

  def deregister_dns
    @result = @service.deregister_dns.result_mesg
    set_flash_messages_and_redirect
  end

private

  def set_service
   @service = ServiceHandler.new params[:id]
  end

  def set_flash_messages_and_redirect
    # if @result.was_success == true
    if @result == 'Success'
        # flash[:notice] = @result.result_mesg
        flash[:notice] = '######WTF! returned String not ReturnObject'
      else
        flash[:error] = @result.result_mesg
    end
    redirect_to app_manager_path
  end

end

