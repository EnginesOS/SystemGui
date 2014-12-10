module EnginesApiHandler

  def self.engines_api
    @enginesOS_api ||= (p "$$$ API object created"; EnginesOSapi.new)
  end

end

