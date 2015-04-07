module EnginesSoftwaresActions

  def stop
    @result = EnginesSoftware.stop params[:id]
    set_flash_messages_and_redirect
  end
  
  def start   
    @result = EnginesSoftware.start params[:id]
    set_flash_messages_and_redirect
  end
  
  def pause
    @result = EnginesSoftware.pause params[:id]
    set_flash_messages_and_redirect
  end
  
  def unpause
    @result = EnginesSoftware.unpause params[:id]
    set_flash_messages_and_redirect
  end
   
  def destroy_container
    p :destroy_container
    @result = EnginesSoftware.destroy_container params[:id]
    set_flash_messages_and_redirect
  end 
  
  def delete_image
    @result = EnginesSoftware.delete_image params[:id], remove_all_application_data: (params[:remove_all_application_data] == '1')
    set_flash_messages_and_redirect
  end
  
  def restart
    @result = EnginesSoftware.restart params[:id]
    set_flash_messages_and_redirect
  end
  
  def create_container
    @result = EnginesSoftware.create_container params[:id]
    set_flash_messages_and_redirect
  end

  def recreate
    @result = EnginesSoftware.recreate params[:id]
    set_flash_messages_and_redirect
  end

  def reinstall
    @result = EnginesSoftware.reinstall_software params[:id]
    set_flash_messages_and_redirect
  end

  def monitor
    @result = EnginesSoftware.monitor params[:id]
    set_flash_messages_and_redirect
  end
  
  def demonitor
    @result = EnginesSoftware.demonitor params[:id]
    set_flash_messages_and_redirect
  end
  
  def register_website
    @result = EnginesSoftware.register_website params[:id]
    set_flash_messages_and_redirect
  end
  
  def deregister_website
    @result = EnginesSoftware.deregister_website params[:id]
    set_flash_messages_and_redirect
  end
  
  def register_dns
    @result = EnginesSoftware.register_dns params[:id]
    set_flash_messages_and_redirect
  end
  
  def deregister_dns
    @result = EnginesSoftware.deregister_dns params[:id]
    set_flash_messages_and_redirect
  end

private

  def set_flash_messages_and_redirect
    if @result.was_success == true
      if @result.result_mesg.blank?
        message = 'Success. (No message in API result object.)'
      else
        message = @result.result_mesg[0..250]
      end
      flash[:notice] = message
    else
      if @result.result_mesg.blank?
        message = 'Unknown error. (No message in API result object.)'
      else
        message = @result.result_mesg[0..250]
      end
      flash[:error] = message
    end
    redirect_to control_panel_path
  end


end