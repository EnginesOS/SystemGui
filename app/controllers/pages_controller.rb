require "EnginesOSapi.rb"
require 'EngineGallery.rb'

class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @engines = $enginesOS_api.getManagedEngines()
    @engines ||= []
    @engines = @engines.select{|e| e.setState == "running"}
    if SettingsConfig.first.present?
      wallpaper = SettingsConfig.first.wallpaper
    end
    if wallpaper.present?
      @wallpaper_url = wallpaper.url
    end
# p "wallpaper_url: " + @wallpaper_url.to_s
    render :home, layout: false
  end

  def app_manager
    @services = $enginesOS_api.getManagedServices()
    @services ||= []

    @engines = $enginesOS_api.getManagedEngines()
    @engines ||= []
  end

  def settings
    @settings = SettingsConfig.first() || SettingsConfig.new
  end

  def installer
    @gallery_servers = Gallery.all.map(&:gallery_server)
p @gallery_servers
    # @gallery_servers = []
    # @galleries.each do |gallery|
    #   @gallery_servers << gallery.gallery_server
    # end
    # @gallery_servers.flatten!
  end

  def system
    @snapshop = Vmstat.snapshot
    sleep(1) #FIXME this is a kludge need to use time stamps and do a wait for or something better then just sleep?
    @vm2 = Vmstat.memory
  end


end
