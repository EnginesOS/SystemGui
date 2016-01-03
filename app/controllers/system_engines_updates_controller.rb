class SystemEnginesUpdatesController < ApplicationController

  def show
    if @system_status[:state] != :engines_updating
      result = System.update_engines
      if result.kind_of?(EnginesOSapiResult)
        if result.was_success
          SystemDataCache.cache_system_update_status
          @system_status = System.status
          # flash[:notice] = result.result_mesg
        else
          redirect_to updater_system_path, alert: ( "Unable to update Engines system. " + result.result_mesg )[0,500]
        end
      else
        redirect_to updater_system_path, alert: "No result"
      end
    end
  end

  def progress
    if @system_status[:state] == :engines_updating
      render text: "busy"
    else
      render text: "done"
      Maintenance.full_maintenance
    end
  end

end
