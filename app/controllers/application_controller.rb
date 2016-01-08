class ApplicationController < ActionController::Base

  rescue_from Exception, :with => :render_500 if ( ENV['SEND_BUG_REPORTS'].present? && ENV['SEND_BUG_REPORTS'] == 'true' ) #if ( defined?(@bug_reports_enabled) && @bug_reports_enabled  )

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authorize
  before_action :setup

  rescue_from ActionController::InvalidAuthenticityToken do
    reset_session
    redirect_to desktop_path, alert: 'Token error. Please sign in again.'
  end

  require '/opt/engines/lib/ruby/api/public/engines_osapi.rb'
  require 'git'
  require 'awesome_print'

protected

  def setup
    set_bug_reports_enabled_flag
    set_system_status unless ajax_call_not_needing_status?
    set_display_settings unless is_an_ajax_call?
    check_for_build_fail if waiting_for_installation?
  end

  def check_for_build_fail
    if @system_status[:did_build_fail]
      SystemDataCache.turn_on_failed_build_flag
    end
  end

  def waiting_for_installation?
    params[:controller] == 'application_installations' && params[:action] == 'progress'
  end

  def set_bug_reports_enabled_flag
    System.send_bug_reports_enabled?
  end

  def is_an_ajax_call?
    ajax_call_not_needing_status? || ajax_call_needing_status?
  end

  def ajax_call_needing_status?
    ['navbar_system_statuses'].include?(params[:controller]) ||
    ['progress'].include?(params[:action])
  end

  def ajax_call_not_needing_status?
    [
      'helps',
      'applications',
      'services',
      'control_panel_applications',
      'control_panel_services',
      'desktop_applications',
      'application_reports',
      'service_reports',
      'application_abouts',
      'service_abouts',
      'library_softwares',
      'system_monitor_charts',
      'control_panel_applications_states',
      'control_panel_services_states'
    ].include? params[:controller]
  end


  def cache_system_update_status
    if (
        ( params[:controller] == 'systems' && params[:action] == 'status' ) ||
        params[:controller] == 'system_base_updates' ||
        params[:controller] == 'system_engines_updates'
      )
      SystemDataCache.cache_system_update_status
    end
  end

  def set_system_status
    if user_signed_in?
      cache_system_update_status
      @system_status = System.status
      return if params[:controller] == 'navbar_system_statuses'
      case @system_status[:state]
      when :restarting
        redirect_to system_restart_path,
          alert: 'Please wait for system to reboot.' \
          if params[:controller] != 'system_restarts'
      when :base_updating
        redirect_to system_base_update_path,
          alert: 'Please wait for base operating system to update.' \
          if params[:controller] != 'system_base_updates'
      when :engines_updating
        redirect_to system_engines_update_path,
          alert: "Please wait for Engines to update." \
          if params[:controller] != 'system_engines_updates'
      when :mgmt_updating
        redirect_to system_restart_mgmt_path,
          alert: "Please wait for the Engines system manager to restart." \
          if params[:controller] != 'system_restart_mgmts'
      when :registry_updating
        redirect_to system_registry_restart_path,
          alert: "Please wait for registry to restart." \
          if params[:controller] != 'system_registry_restarts'
      when :installing
        redirect_to installing_application_installation_path,
          alert: 'Please wait for current installation to complete.' \
          if ( params[:controller] == 'install_from_blueprints' ||
              params[:controller] == 'install_from_repository_urls' ||
              params[:controller] == 'install_from_docker_hubs' ||
              params[:controller] == 'system_restarts' )
      end
    end
  end

  def set_display_settings
    @display_settings = DisplaySettings.instance
    @page_title = @display_settings.system_title || 'Engines'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  def authorize
     params[:controller] == 'desktops' ||
     params[:controller] == 'desktop_applications' ||
     params[:controller] == 'helps' ||
     (params[:controller] == 'first_runs' && params[:action] == 'done') ||
     devise_controller? ||
     authenticate
  end

  def authenticate
    return authenticate_user! if user_signed_in?
    respond_to_unauthenticated_request
  end

  def respond_to_unauthenticated_request
    if is_an_ajax_call?
      render text: "Please sign in to continue.", status: 401
    else
      redirect_to desktop_path, alert: "Please sign in to continue."
    end
  end

  def after_sign_in_path_for(resource)
    Maintenance.full_maintenance
    SystemDataCache.cache_system_update_status
    if FirstRun.required? ##&& !Rails.env.development?
      first_run_path
    else
      control_panel_path
    end
  end

  def render_500(exception)

# ENV['SEND_BUG_REPORTS'] = false.to_s
p :send_bug_reports_check
p ENV['SEND_BUG_REPORTS']


    SystemUtils.log_exception exception
    @exception = exception
    render 'systems/500', :status => 500, layout: 'empty_navbar'
  end

end
