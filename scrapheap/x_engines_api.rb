module EnginesApi

  def self.api
    @engines_api ||= (EnginesOSapi.new)
  end

end