class SystemsController < ApplicationController

  def show
  end

  def info
  end

  def status
    SystemDataCache.cache_system_update_status
  end

  def monitor
    SystemDataCache.cache_memory_statistics
    # render text: Vmstat.methods
  end
#
  # def monitor_memory
  # end
#
  # def monitor_processors
  # end
#
  # def monitor_io
  # end

  def logs

  end

  def base_system
  end

  def updater
  end

  def restart
  end

  def restart_registry
  end

end
