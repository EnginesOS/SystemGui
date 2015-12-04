module System

  extend Engines::Api

  def self.restart
    engines_api.restart_system
  end

  def self.update_base
    result = engines_api.update_system
    SystemDataCache.cache_system_update_status
    result
  end

  def self.update_engines
    result = engines_api.update_engines_system_software
    SystemDataCache.cache_system_update_status
    result
  end

  def self.system_status_from_api
    engines_api.system_status.merge(SystemDataCache.system_update_status).merge(@build_status_from_api)
  end

  def self.build_status_from_api
    engines_api.build_status
  end

  def self.restart_mgmt
    engines_api.restart_mgmt
  end

  def self.restart_registry
    engines_api.restart_registry
  end

  def self.cancel_installation
    engines_api.abort_build
  end

  def self.unit_name
    engines_api.system_hostname
  rescue
    "system_hostname api method missing"
  end

  def self.cache_send_bug_reports
    ENV['SEND_BUG_REPORTS'] = ( engines_api.is_remote_exception_logging? == true ).to_s
  end

  def self.send_bug_reports_enabled?
    ENV['SEND_BUG_REPORTS'].present? || cache_send_bug_reports
    ENV['SEND_BUG_REPORTS'] == 'true'
  end

  def self.execute_command(command)
    SystemUtils.execute_command(command)
  end

  def self.get_changed_containers
    engines_api.get_changed_containers
  end

  def self.cache_build_status
    @build_status_from_api = build_status_from_api
  end

  def self.status
    cache_build_status
    status_from_api = system_status_from_api
    {system: status_from_api}.merge(
      if status_from_api[:is_rebooting]
        {state: :restarting, message: "System rebooting", message_class: :warning, title: 'Please wait for system to reboot', reload: true}
      elsif status_from_api[:is_mgmt_restarting]
        {state: :mgmt_restarting, message: "System manager restarting", message_class: :warning, title: 'Please wait for system manager to restart', reload: true}
      elsif status_from_api[:is_registry_restarting]
        {state: :registry_restarting, message: "Restarting registry", message_class: :warning, title: 'Please wait for registry to retart', reload: true}
      elsif @build_status_from_api[:is_building]
        {state: :installing, message: "Installing", message_class: :warning, button_url: '/application_installation/installing', title: 'Click to monitor installation progress', reload: true}
      elsif status_from_api[:is_engines_system_updating]
        {state: :engines_updating, message: "Updating Engines", message_class: :warning, title: 'Please wait for Engines to update', reload: true}
      elsif status_from_api[:is_base_system_updating]
        {state: :base_updating, message: "Updating base", message_class: :warning, title: 'Please wait for the base system to update', reload: true}
      elsif status_from_api[:needs_reboot]
        {state: :needs_restart ,message: "Reboot required", message_class: :danger, title: 'Click to reboot the system', button_url: '/system/restart'}
      elsif status_from_api[:needs_engines_update]
        {state: :needs_engines_update ,message: "Engines update required", message_class: :danger, title: 'Click to update Engines', button_url: '/system/updater'}
      elsif status_from_api[:needs_base_update]
        {state: :needs_base_update ,message: "Base OS update required", message_class: :danger, title: 'Click to update the base system', button_url: '/system/updater'}
      else
        {state: :ok, message: "OK", message_class: :ok, title: 'System status'}
      end)
  end

  def self.build_params
    current_build_params = engines_api.current_build_params
    current_build_params.present? ? current_build_params : engines_api.last_build_params
  end

  def self.installing_params
    params = build_params
    {application_name: params[:engine_name],
     host_name: params[:host_name],
     domain_name: params[:domain_name] }
  end

  def self.waiting_for_installation_to_commence
    !@build_status_from_api[:is_building] && SystemDataCache.instance.failed_build_flag != true
  end

end
