class UserSessionsController < Devise::SessionsController
  # before_filter :before_login, :only => :create
  # after_filter :after_login, :only => :create
  #
  # def before_login
  # end
  #
  # def after_login
  #
  #
  # end

  def create

p :create_new_user_session

    Maintenance.full_maintenance
    SystemDataCache.cache_system_update_status

p :cached_system_update_status
p SystemDataCache.system_update_status

    p :about_to_sign_in

    super
      p :now_signed_in


  end

end
