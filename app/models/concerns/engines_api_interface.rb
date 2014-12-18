module EnginesApiInterface

  def self.engines_api
    @engines_api ||= (p "$$$ API object created"; EnginesOSapi.new)
  end

end