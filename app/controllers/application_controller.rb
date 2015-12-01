class ApplicationController < ActionController::Base

  protect_from_forgery with: :reset_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authorize

  rescue_from Exception, :with => :render_500 #if ( Rails.env.production? && System.send_bug_reports_enabled? )

  require '/opt/engines/lib/ruby/api/public/engines_osapi.rb'
  require 'git'
  require 'awesome_print'

  before_action :setup

protected

  def setup
    System.check_send_bug_reports_flag_is_cached
    return if status_and_page_title_not_needed?
    set_system_status
    return if status_needed_and_page_title_not_needed?
    set_page_title
  end

  def status_needed_and_page_title_not_needed?
    ['navbar_system_statuses'].include?(params[:controller]) ||
    ['progress'].include?(params[:action])
  end

  def status_and_page_title_not_needed?
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
      'gallery_softwares',
      'system_monitor_charts',
      'first_runs'
    ].include? params[:controller]
  end

  def set_system_status
    if user_signed_in?
      @system_status = System.status
      return if params[:controller] == 'navbar_system_statuses'
      case @system_status[:state]
      when :restarting
        redirect_to system_restart_path,
          alert: 'Please wait for system to reboot.' \
          if params[:controller] != 'system_restarts'
      when :base_updating
        redirect_to system_base_update_path,
          alert: 'Please wait for system to update.' \
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

  def set_page_title
    @@page_title ||= "#{System.unit_name.to_s.humanize} Engines"
    @page_title = @@page_title
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
     devise_controller? ||
     authenticate
  end

  def authenticate
    return authenticate_user! if user_signed_in?
    if status_and_page_title_not_needed? || status_needed_and_page_title_not_needed?
      render text: "Your session expired. Please sign in again to continue.", status: 401
    else
      redirect_to desktop_path
    end
  end

  def after_sign_in_path_for(resource)
    Maintenance.full_maintenance
    System.cache_system_update_status
    if FirstRun.required?
      first_run_path
    else
      control_panel_path
    end
  end

  def render_500(exception)
    SystemUtils.log_exception exception
    @exception = exception
    render 'systems/500', :status => 500, layout: 'empty_navbar'
  end

end
