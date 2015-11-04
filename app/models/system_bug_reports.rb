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
    self.enable = engines_api.is_remote_exception_logging?
    self
  end

  def persist
    if enable == '1'
      engines_api.enable_remote_exception_logging
    else
      engines_api.disable_remote_exception_logging
    end.was_success
  end
  
  def new_record?
    false
  end
  
end