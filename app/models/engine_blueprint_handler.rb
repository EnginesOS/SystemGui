class EngineBlueprintHandler

  attr_accessor :engine_name  

  def initialize opts
    @engine_name = opts[:engine_name]
  end

  def software
    blueprint['software']
  end

  def repository
    blueprint["repository"]
  end

private

  def blueprint
    AppHandler.new(engine_name).blueprint
  end

end