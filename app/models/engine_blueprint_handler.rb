class EngineBlueprintHandler

  attr_accessor :engine_name  
  attr_accessor :blueprint

  def initialize opts
    @engine_name = opts[:engine_name]
    @blueprint = load_blueprint
  end

  def software
    blueprint['software']
  end

  def repository
    blueprint["repository"]
  end

private

  def load_blueprint
    AppHandler.new(engine_name).blueprint
  end

end