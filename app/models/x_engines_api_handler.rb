module xEnginesApi

  def self.engines_api
    @enginesOS_api ||= (p "$$$ API object created"; EnginesOSapi.new)
  end

  def engines_api
    self.engines_api
  end

end

