class xGalleryHandler
  
  attr_accessor :url

  def initialize(params)
    @url = params[:url]
  end
  
  def blueprints
    @blueprints ||= load_blueprints
  end

  def load_blueprints
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

  def search_blueprint_titles search_string
    if search_string.nil?
      blueprints
    else
      blueprints.select{|blueprint| blueprint['full_name'].downcase.include? search_string.downcase }
    end
  end
  
end