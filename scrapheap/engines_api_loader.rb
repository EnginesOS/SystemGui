module EnginesApiLoader

  def self.engines_api
    @engines_api ||= (EnginesOSapi.new)
  end

end