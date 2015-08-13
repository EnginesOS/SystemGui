class SystemUpdatesController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update_base
    result = System.update_base
    if result.kind_of?(EnginesOSapiResult)
      if result.was_success
        redirect_to updating_system_update_path
      else
        redirect_to system_update_path, alert: ( "Unable to update base system. " + result.result_mesg )[0,500]
      end
    else
      redirect_to system_update_path, alert: "No result"
    end
  end
  
  def updating
    render layout: 'empty_navbar'
  end

  def update_engines
    result = System.update_engines
    if result.kind_of?(EnginesOSapiResult)
      if result.was_success
        redirect_to updating_system_update_path
      else
        redirect_to system_update_path, alert: ( "Unable to update Engines system. " + result.result_mesg )[0,500]
      end
    else
      redirect_to system_update_path, alert: "No result"
    end
  end

end
