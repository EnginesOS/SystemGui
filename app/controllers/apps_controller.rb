class AppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app_handler
  # after_action :set_flash_messages_and_redirect, except: [:advanced_detail]

  def advanced_detail
    render partial: "advanced_detail"
  end

  def stop
    @result = @app.stop
    set_flash_messages_and_redirect
  end
  
  def start   
    @result = @app.start
    set_flash_messages_and_redirect
  end
  
  def pause
    @result = @app.pause
    set_flash_messages_and_redirect
  end
  
  def unpause
    @result = @app.unpause
    set_flash_messages_and_redirect
  end
   
  def destroy_container
    @result = @app.destroy_container
    set_flash_messages_and_redirect
  end 
  
  def delete_image
    @result = @app.delete_image
    set_flash_messages_and_redirect
  end 
  
  def restart
    @result = @app.restart
    set_flash_messages_and_redirect
  end
  
  def create_container
    @result = @app.create_container
    set_flash_messages_and_redirect
  end

  def recreate
    @result = @app.recreate
    set_flash_messages_and_redirect
  end

  def monitor
    @result = @app.monitor
    set_flash_messages_and_redirect
  end
  
  def demonitor
    @result = @app.demonitor
    set_flash_messages_and_redirect
  end
  
  def register_website
    @result = @app.register_website
    set_flash_messages_and_redirect
  end
  
  def deregister_website
    @result = @app.deregister_website
    set_flash_messages_and_redirect
  end
  
  def register_dns
    @result = @app.register_dns
    set_flash_messages_and_redirect
  end
  
  def deregister_dns
    @result = @app.deregister_dns
    set_flash_messages_and_redirect
  end

private

  def set_app_handler

p 'create AppHandler with id of'
p params[:id]

    @app = AppHandler.new params[:id]
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
