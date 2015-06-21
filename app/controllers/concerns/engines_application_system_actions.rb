module EnginesApplicationSystemActions

  def stop
    @result = @application.stop
    set_flash_messages_and_redirect
  end
  
  def start   
    @result = @application.start
    set_flash_messages_and_redirect
  end
  
  def pause
    @result = @application.pause
    set_flash_messages_and_redirect
  end
  
  def unpause
    @result = @application.unpause
    set_flash_messages_and_redirect
  end
   
  def destroy_container
    @result = @application.destroy_container
    set_flash_messages_and_redirect
  end 
  
  def delete_image
    @result = @application.delete_image remove_all_application_data: params[:remove_all_application_data]
    set_flash_messages_and_redirect
  end
  
  def restart
    @result = @application.restart
    set_flash_messages_and_redirect
  end
  
  def create_container
    @result = @application.create_container
    set_flash_messages_and_redirect
  end

  def recreate
    @result = @application.recreate
    set_flash_messages_and_redirect
  end

  def reinstall
    @result = @application.reinstall_software
    set_flash_messages_and_redirect
  end

  def monitor
    @result = @application.monitor
    set_flash_messages_and_redirect
  end
  
  def demonitor
    @result = @application.demonitor
    set_flash_messages_and_redirect
  end
  
  def register_website
    @result = @application.register_website
    set_flash_messages_and_redirect
  end
  
  def deregister_website
    @result = @application.deregister_website
    set_flash_messages_and_redirect
  end
  
  def register_dns
    @result = @application.register_dns
    set_flash_messages_and_redirect
  end
  
  def deregister_dns
    @result = @application.deregister_dns
    set_flash_messages_and_redirect
  end

private

  def set_flash_messages_and_redirect
    if @result.was_success == true
      render partial: 'control_panel_applications/show'   
    else
      if @result.result_mesg.blank?
        flash_message = 'Failed with unknown error. (No message in API result object.)'
      else
        flash_message = @result.result_mesg[0..500]
      end
      # flash[:error] = message
      render partial: 'control_panel_applications/show', locals: { flash_message: flash_message }   
    end
    # redirect_to control_panel_path
  end

end