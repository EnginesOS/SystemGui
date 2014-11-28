module EnginesApiHandler

  def self.engines_api
    @enginesOS_api ||= (p "$$$$$$$$$$$$$$$$$$$$$$$$$$$ API call"; EnginesOSapi.new)
  end

end

