class UserSessionsController < Devise::SessionsController

  def create
    Maintenance.full_maintenance
    SystemDataCache.cache_system_update_status
    super
  end

end
