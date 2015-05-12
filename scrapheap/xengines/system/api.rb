module Engines::System::Api

  def self.api
    @engines_system_api ||= (EnginesOSapi.new)
  end

end