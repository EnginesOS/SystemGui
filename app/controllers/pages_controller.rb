class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @settings = SystemConfig.settings
    @app_installs = EnginesSoftware.user_visible_applications.map(&:app_install).sort_by(&:engine_name)
    render :home, layout: false
  end

  def control_panel
    Maintenance.db_maintenance
    @software = Software.all.sort_by(&:engine_name)
    @services = Service.all.sort_by(&:engine_name)
    # render text: @software.map(&:engine_name)
  end

  def system
    @system_info = EnginesSystem.system_info
    @snapshop = Vmstat.snapshot
    sleep(1)
    @vm2 = Vmstat.memory
  end

  def installer
    if SystemConfig.settings.default_domain.blank?
      redirect_to(edit_default_domain_path, alert: "Please set a default domain before installing software.")
    else
      @gallery_installs = Gallery.all
    end
  end

# private

#     def services
#       services = EnginesApi.enginesOS_api.getManagedServices()
#       services ||= []
#     end

end
