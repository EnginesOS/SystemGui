module EnginesServices
  Actions

  def create_container
    @result = EnginesService.create_container params[:id]
    set_flash_messages_and_redirect
  end

  def recreate
    @result = EnginesService.recreate params[:id]
    set_flash_messages_and_redirect
  end

  def stop
    @result = EnginesService.stop params[:id]
    set_flash_messages_and_redirect
  end

  def start
    @result = EnginesService.start params[:id]
    set_flash_messages_and_redirect
  end

  def pause
    @result = EnginesService.pause params[:id]
    set_flash_messages_and_redirect
  end

  def unpause
    @result = EnginesService.unpause params[:id]
    set_flash_messages_and_redirect
  end

  def register_website
    @result = EnginesService.register_website params[:id]
    set_flash_messages_and_redirect
  end

  def deregister_website
    @result = EnginesService.deregister_website params[:id]
    set_flash_messages_and_redirect
  end

  def register_dns
    @result = EnginesService.register_dns params[:id]
    set_flash_messages_and_redirect
  end

  def deregister_dns
    @result = EnginesService.deregister_dns params[:id]
    set_flash_messages_and_redirect
  end

private

  def set_flash_messages_and_redirect
    if @result.was_success == true
      flash[:notice] = @result.result_mesg[0..250]
    else
      flash[:error] = @result.result_mesg[0..250]
    end
    redirect_to control_panel_path
  end

end