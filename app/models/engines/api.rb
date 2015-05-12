module Engines::Api

  def engines_api
    Engines::ApiLoader.instance.engines_api
  end

end