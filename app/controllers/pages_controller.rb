require "EnginesOSapi.rb"

class PagesController < ApplicationController
  before_action :authenticate_user!

  def control_panel
    @services = @enginesOS_api.getManagedServices()
    @services ||= []

    @engines = @enginesOS_api.getManagedEngines()
    @engines ||= []

    @snapshop = Vmstat.snapshot
    sleep(1) #FIXME this is a kludge need to use time stamps and do a wait for or something better then just sleep?
    @vm2 = Vmstat.memory
  end

end
