module EnginesServicesSystemActions

  def create_container
    do_service_action :create_container
  end

  def recreate
    do_service_action :recreate
  end

  def stop
    do_service_action :stop
  end

  def start
    do_service_action :start
  end

  def pause
    do_service_action :pause
  end

  def unpause
    do_service_action :unpause
  end

  def register_website
    do_service_action :register_website
  end

  def deregister_website
    do_service_action :deregister_website
  end

  def register_dns
    do_service_action :register_dns
  end

  def deregister_dns
    do_service_action :deregister_dns
  end
  
  def reload
    sleep(0.2)
    render partial: 'control_panel_services/show'
  end

private

  def do_service_action(action)
    result = @service.send(action)
    if result.was_success
      render partial: 'control_panel_services/show'
    else
      render partial: 'control_panel_services/show', alert: "Error. #{result.result_mesg[0..500]}"
    end
  end

end