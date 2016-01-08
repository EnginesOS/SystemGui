module EnginesServicesSystemActions

  def create_container
    do_service_action :create_container
  end

  def recreate_container
    do_service_action :recreate_container
  end

  def stop_container
    do_service_action :stop_container
  end

  def start_container
    do_service_action :start_container
  end

  def pause_container
    do_service_action :pause_container
  end

  def unpause_container
    do_service_action :unpause_container
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
