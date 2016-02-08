class SystemDataCache < ActiveRecord::Base

  def self.instance
    first_or_create
  end

  def self.cache_memory_statistics
    instance.update(memory_statistics: SystemInfo.memory_statistics.to_json)
  end

  def self.memory_statistics
    cache_memory_statistics if instance.memory_statistics.nil?
    JSON.parse(instance.memory_statistics).deep_symbolize_keys
  end


  def self.cache_system_build_fail
    if System.build_status_from_api[:did_build_fail]
      turn_on_failed_build_flag
    end
  end

  def self.failed_build_flag
p :check_failed_build_flag
p instance.failed_build_flag
p :done_check_failed_build_flag

    instance.failed_build_flag == true
  end

  def self.clear_failed_build_flag
p :turn_off_failed_build_flag
    instance.update(failed_build_flag: false)
  end

  def self.turn_on_failed_build_flag
p :turn_on_failed_build_flag
    instance.update(failed_build_flag: true)
  end


  def self.system_update_status
      cache_system_update_status if instance.system_update_status.nil?
      JSON.parse(instance.system_update_status).deep_symbolize_keys # || {}
  end

  def self.cache_system_update_status
    instance.update(system_update_status: SystemInfo.system_update_status.to_json)
  end

end
