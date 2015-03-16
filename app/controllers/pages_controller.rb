class PagesController < ApplicationController
  before_action :authenticate_user!

  def start
    if EnginesFirstRun.required?
      redirect_to(first_run_path)
    else
      redirect_to(desktop_path)
    end
  end      

  def desktop
    EnginesMaintenance.full_maintenance
    @settings = Setting.first_or_create
    @softwares = Software.user_visible_applications.sort_by(&:engine_name)
    # flash[:alert] = "fake alert"
    # flash[:notice] = "fake notice"
    render :desktop, layout: false
  end

  def control_panel
    EnginesMaintenance.full_maintenance
    @softwares = Software.all.sort_by(&:engine_name)
    @service_names = EnginesService.all_service_names.sort
  end

  def system
    @system_info = EnginesSystem.system_info
    @snapshop = Vmstat.snapshot
    sleep(1)
    @vm2 = Vmstat.memory
  end

end
