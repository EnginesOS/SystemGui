class UserSessionsController < Devise::SessionsController
  before_filter :before_login, :only => :create
  after_filter :after_login, :only => :create

  def before_login
  end

  def after_login

    p :now_signed_in

        Maintenance.full_maintenance
        SystemDataCache.cache_system_update_status

    p :cached_system_update_status
    p SystemDataCache.system_update_status

  end
end
