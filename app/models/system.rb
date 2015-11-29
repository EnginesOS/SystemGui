module System

  extend Engines::Api
  
  def self.restart
    engines_api.restart_system
  end
  
  def self.update_base
    result = engines_api.update_system
    cache_system_update_status
    result
  end

  def self.update_engines
    result = engines_api.update_engines_system_software
    cache_system_update_status
    result
  end
  
  def self.system_status_from_api
    cache_system_update_status if defined?(@@system_update_status_from_api).nil?
    engines_api.system_status.merge @@system_update_status_from_api
  end
  
  def self.build_status_from_api
    engines_api.build_status
  end
  
  def self.cache_system_update_status
    @@system_update_status_from_api = SystemStatus.system_update_status
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

  def self.cache_send_bug_reports_enabled 
    ENV['SEND_BUG_REPORTS'] = ( engines_api.is_remote_exception_logging? == true ).to_s
  end

  def self.check_send_bug_reports_flag_is_cached 
    # cache_send_bug_reports_enabled if ENV['SEND_BUG_REPORTS'].nil?
    true
  end
  
  def self.send_bug_reports_enabled?
    return true if ENV['SEND_BUG_REPORTS'].nil?
    ENV['SEND_BUG_REPORTS'] == 'true'
  end

  def self.execute_command(command)  
    SystemUtils.execute_command(command)
  end

  def self.status
    @status_from_api = system_status_from_api
    @build_status_from_api = build_status_from_api
    if @build_status_from_api[:did_build_fail]
      @@failed_build_flag = true
    end
    {system: @status_from_api,builder: @build_status_from_api}.merge(
      if @status_from_api[:is_rebooting]
        {state: :restarting, message: "System rebooting", message_class: :warning, title: 'Please wait for system to reboot', reload: true}
      elsif @status_from_api[:is_mgmt_restarting]
        {state: :mgmt_restarting, message: "System manager restarting", message_class: :warning, title: 'Please wait for system manager to restart', reload: true}
      elsif @status_from_api[:is_registry_restarting]
        {state: :registry_restarting, message: "Restarting registry", message_class: :warning, title: 'Please wait for registry to retart', reload: true}
      elsif @build_status_from_api[:is_building]
        {state: :installing, message: "Installing", message_class: :warning, button_url: '/application_installation/installing', title: 'Click to monitor installation progress', reload: true}
      elsif @status_from_api[:is_engines_system_updating]
        {state: :engines_updating, message: "Updating Engines", message_class: :warning, title: 'Please wait for Engines to update', reload: true}
      elsif @status_from_api[:is_base_system_updating]
        {state: :base_updating, message: "Updating base", message_class: :warning, title: 'Please wait for the base system to update', reload: true}
      elsif @status_from_api[:needs_reboot]
        {state: :needs_restart ,message: "Reboot required", message_class: :danger, title: 'Click to reboot the system', button_url: '/system/restart'}
      elsif @status_from_api[:needs_engines_update]
        {state: :needs_engines_update ,message: "Engines update required", message_class: :danger, title: 'Click to update Engines', button_url: '/system/updater'}
      elsif @status_from_api[:needs_base_update]
        {state: :needs_base_update ,message: "Base OS update required", message_class: :danger, title: 'Click to update the base system', button_url: '/system/updater'}
      else
        {state: :ok, message: "OK", message_class: :ok, title: 'System status'}
      end)
  end

  def self.current_build_params
    @current_build_params ||= engines_api.current_build_params
  end

  def self.last_build_params
    @last_build_params ||= engines_api.last_build_params
  end
  
  def self.build_params
    return current_build_params if current_build_params.present?
    last_build_params
  end

  def self.installing_params
    {application_name: build_params[:engine_name],
     host_name: build_params[:host_name],
     domain_name: build_params[:domain_name] }
  end

  def self.waiting_for_installation
    !@build_status_from_api[:is_building] && @@failed_build_flag != true
  end
  
  def self.clear_failed_build_flag
    @@failed_build_flag = false    
  end

end