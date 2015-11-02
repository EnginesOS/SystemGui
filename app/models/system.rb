module System

  extend Engines::Api
  
  def self.restart
    engines_api.restart_system
  end
  
  def self.update_base
    engines_api.update_system
  end

  def self.update_engines
    engines_api.update_engines_system_software
  end
  
  def self.system_status_from_api
    engines_api.system_status
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
  
  def self.unit_name
    execute_command('hostname')[:stdout].strip || 'Engines - unknown hostname'
  end

  def self.execute_command(command)  
    SystemUtils.execute_command(command)
  end


  def self.status
    @status_from_api = system_status_from_api
    @build_status_from_api = build_status_from_api
    if @build_status_from_api[:did_build_fail]
      ENV['FAILED_BUILD_FLAG'] = 'true'
    end
    {system: @status_from_api,builder: @build_status_from_api}.merge(
      if @status_from_api[:is_rebooting]
        {state: :restarting, message: "Rebooting", message_class: :warning}
      elsif @status_from_api[:is_mgmt_restarting]
        {state: :mgmt_restarting, message: "System manager restarting", message_class: :warning}
      elsif @status_from_api[:is_registry_restarting]
        {state: :registry_restarting, message: "Registry restarting", message_class: :warning}
      elsif @status_from_api[:is_engines_system_updating]
        {state: :engines_updating, message: "Updating", message_class: :warning}
      elsif @status_from_api[:is_base_system_updating]
        {state: :base_updating, message: "Updating", message_class: :warning}
      elsif @build_status_from_api[:is_building]
        {state: :installing, message: "Installing", message_class: :warning, button_url: '/application_installation/installing'}
      elsif @status_from_api[:needs_reboot]
        {state: :needs_restart ,message: "Reboot required", message_class: :danger, button_url: '/system/restart'}
      elsif @status_from_api[:needs_engines_update]
        {state: :needs_engines_update ,message: "Engines update required", message_class: :danger, button_url: '/system/updater'}
      elsif @status_from_api[:needs_base_update]
        {state: :needs_base_update ,message: "Base update required", message_class: :danger, button_url: '/system/updater'}
      else
        {state: :ok, message: "OK", message_class: :ok}
      end)
  end

  def self.installing_params
    stored_build_params = engines_api.current_build_params
    {application_name: stored_build_params[:engine_name],
     host_name: stored_build_params[:host_name],
     domain_name: stored_build_params[:domain_name] }
  end

  # def self.restarting?;                       status[:state] == :restarting; end
  # def self.mgmt_restarting?;                  status[:state] == :mgmt_restarting; end
  # def self.registry_restarting?;              status[:state] == :registry_restarting; end
  # def self.engines_updating?;                 status[:state] == :engines_updating; end
  # def self.base_system_updating?;             status[:state] == :base_updating; end
  # def self.installing?;                       status[:state] == :installing; end
  # def self.needs_restart?;                    status[:state] == :needs_restart; end

  def self.waiting_for_installation
    !@build_status_from_api[:is_building] && ENV['FAILED_BUILD_FLAG'] != 'true'
  end
  
  def self.clear_failed_build_flag
    ENV['FAILED_BUILD_FLAG'] = nil    
  end

end