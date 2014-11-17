class ApplicationController < ActionController::Base

  require 'EnginesApiHandler.rb'
  include EnginesApiHandler
  require 'EngineGallery.rb'

  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller? 
  
  # def enginesOS_api
  #   return $enginesOS_api
  # end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    user_session_path
  end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

end
