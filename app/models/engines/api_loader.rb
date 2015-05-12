module Engines

  require 'singleton'

  class ApiLoader
  
    include Singleton
  
    def engines_api
      @@engines_api ||= (EnginesOSapi.new)
    end
  
  end
  
end