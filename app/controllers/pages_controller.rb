class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @settings = SystemConfig.settings
    @app_installs = AppHandler.user_visible_applications.map(&:app_install).sort_by(&:engine_name)
    render :home, layout: false
  end

  def app_manager
    Maintenance.db_maintenance
    @app_installs = AppHandler.all.map(&:app_install).sort_by(&:engine_name)
    @services = ServiceHandler.all.sort_by(&:engine_name)
  end

  def system
    @system_info = SystemHandler.system_info
    @snapshop = Vmstat.snapshot
    sleep(1)
    @vm2 = Vmstat.memory
  end

  def settings
    @settings = SystemConfig.settings
    @users = User.all
    @backup_tasks = BackupTask.all
    @gallery_installs = GalleryInstall.all
  end

  def installer
    if SystemConfig.settings.default_domain.blank?
      redirect_to(edit_default_domain_path, alert: "Please set a default domain before installing software.")
    else
      @gallery_installs = GalleryInstall.all
    end
  end

private

    def services
      services = EnginesApiHandler.enginesOS_api.getManagedServices()
      services ||= []
    end

end
