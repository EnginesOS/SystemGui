# require "EnginesOSapi.rb"
# require 'EngineGallery.rb'

class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @applications = user_visible_applications
    @wallpaper_url = wallpaper_url
    render :home, layout: false
  end

  def app_manager
    @applications = get_all_applications
    @services = services
  end

  def system
    @snapshop = Vmstat.snapshot
    sleep(1)
    @vm2 = Vmstat.memory
  end

  def settings
    @system_config = SystemConfig.settings
  end

private

    def services
      services = $enginesOS_api.getManagedServices()
      services ||= []
    end

    def wallpaper_url
      wallpaper = SystemConfig.first.wallpaper if SystemConfig.first.present?
      return wallpaper.url if wallpaper.present?
    end

end
