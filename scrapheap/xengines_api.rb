# require 'singleton'

module EnginesApi
  # include Singleton

  def self.engines_api
    @eninges_api ||= EnginesOSapi.new
  end

end