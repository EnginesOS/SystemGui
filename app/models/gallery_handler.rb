
class GalleryHandler
  
  attr_accessor :url

  def initialize(params)
    @url = params[:url]
  end
  
  def list_blueprints
    uri = URI(url)
    return {} if (uri.host.nil? || uri.port.nil?)
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri
      response = http.request request # Net::HTTPResponse object
      if response.code.to_i >= 200 && response.code.to_i < 400 
        return JSON.parse(response.body) 
      else
        return {} #FIXME should put error mesg somewhere
      end    
    end
  end

  # def get_blueprint blueprint_id
  #   BlueprintHandler.new

  
  
end