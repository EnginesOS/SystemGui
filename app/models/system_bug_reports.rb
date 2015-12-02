class SystemBugReports

  include Engines::Api
  include ActiveModel::Model
  
  attr_accessor :enable

  def self.new(params={})
    if params.present?
      super(params)
    else
      super.load
    end
  end

  def load
    self.enable = System.send_bug_reports_enabled?
    self
  end

  def persist
    if enable == '1'
      engines_api.enable_remote_exception_logging
    else
      engines_api.disable_remote_exception_logging
    end.was_success
    System.cache_send_bug_reports_enabled
  end
  
  def new_record?
    false
  end
  
end