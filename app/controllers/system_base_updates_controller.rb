class SystemBaseUpdatesController < ApplicationController

  def show
    if @system_status[:state] != :base_updating
      result = System.update_base
      if result.kind_of?(EnginesOSapiResult)
        if result.was_success
          SystemDataCache.cache_system_update_status
          @system_status = System.status
          flash[:notice] = result.result_mesg
        else
          redirect_to updater_system_path, alert: ( "Unable to update base system. " + result.result_mesg )[0,500]
        end
      else
        redirect_to updater_system_path, alert: "No result"
      end
    end
  end

  def progress
    if @system_status[:state] == :base_updating
      render text: "busy"
    else
      render text: "done"
      SystemDataCache.cache_system_update_status
    end
  end

end
