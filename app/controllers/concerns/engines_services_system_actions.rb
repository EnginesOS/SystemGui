module EnginesServicesSystemActions

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

  def set_flash_messages_and_redirect
    if @result.was_success == true
      flash_message = @result.result_mesg[0..250]
    else
      flash_message = @result.result_mesg[0..250]
    end
    render 'control_panel_services/show', flash_message: flash_message, layout: false    
    # redirect_to control_panel_path
  end

end