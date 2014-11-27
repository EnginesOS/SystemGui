module EnginesApiHandler

  def self.engines_api
    @@enginesOS_api ||= EnginesOSapi.new
  end

end

