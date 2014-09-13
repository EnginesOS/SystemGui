require "EnginesOSapi.rb"
require 'EngineGallery.rb'

class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @engines = @enginesOS_api.getManagedEngines()
    @engines ||= []
    @engines = @engines.select{|e| e.read_state == "running"}
    render :home, layout: false
  end

  def app_manager
    @services = @enginesOS_api.getManagedServices()
    @services ||= []

    @engines = @enginesOS_api.getManagedEngines()
    @engines ||= []
  end

  def installer
    @galleries = Gallery.all
    @gallery_servers = []
    @galleries.each do |gallery|
      @gallery_servers << gallery.gallery_server
    end
    @gallery_servers.flatten!
  end

  def galleries
    @galleries = Gallery.all
    @added_gallery_servers = []
    @galleries.each do |gallery|
      @added_gallery_servers << gallery.gallery_server
    end
    @added_gallery_server_short_names = @added_gallery_servers.map(&:short_name)
    @all_gallery_servers = EngineGallery.list_local
    @all_gallery_server_short_names = @all_gallery_servers.map(&:short_name)
    @unadded_gallery_server_short_names = @all_gallery_server_short_names - @added_gallery_server_short_names

    @unadded_gallery_servers = []
    @unadded_gallery_server_short_names.each do |unadded_gallery_server_short_name|
      @all_gallery_servers.each do |gallery_server|
        if gallery_server.short_name == unadded_gallery_server_short_name
          @unadded_gallery_servers << gallery_server
        end
      end
    end
  end

  def system
    @snapshop = Vmstat.snapshot
    sleep(1) #FIXME this is a kludge need to use time stamps and do a wait for or something better then just sleep?
    @vm2 = Vmstat.memory
  end

end
