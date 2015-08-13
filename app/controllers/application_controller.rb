class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller? 

  rescue_from Exception, :with => :render_500
  
  require "/opt/engines/lib/ruby/EnginesOSapi.rb"
  require 'git'
  require "awesome_print"

  # Overwriting the devise sign_out redirect path method
  # def after_sign_out_path_for(resource_or_scope)
    # new_user_session_path
  # end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to desktop_path
    end
  end
  
  def after_sign_in_path_for(resource)
    first_runs_path
  end

  def render_500(exception)
    @page_title = "Engines error (500)"
    @exception = exception
    render "shared/500", :status => 500, layout: "empty_navbar"
  end

end