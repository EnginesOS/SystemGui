class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @apps = AppHandler.user_visible_applications.sort_by{|app| app.engine_name}
    @wallpaper_url = wallpaper_url
    render :home, layout: false
  end

  def app_manager
    Maintenance.db_maintenance
    @apps = AppHandler.all.sort_by{|e| e.engine_name}
    @services = ServiceHandler.all.sort_by{|e| e.engine_name}
  end

  def system
    @system_info = SystemHandler.system_info
    @snapshop = Vmstat.snapshot
    sleep(1)
    @vm2 = Vmstat.memory
  end

  def settings
    @settings = SystemConfig.settings

p 'pages controller hosted settings..................'
p @settings.hosted_domains

    @users = User.all
    @backup_tasks = BackupTask.all
    @gallery_installs = GalleryInstall.all
  end

  def installer
    @gallery_installs = GalleryInstall.all
  end

private

    def services
      services = EnginesApiHandler.enginesOS_api.getManagedServices()
      services ||= []
    end

    def wallpaper_url
      wallpaper = SystemConfig.first.wallpaper if SystemConfig.first.present?
      return wallpaper.url if wallpaper.present?
    end

end
