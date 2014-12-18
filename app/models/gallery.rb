class Gallery < ActiveRecord::Base


  # def all
  #   EnginesGallery.all
  #   @gallery_handler ||= EnginesGallery.new(url: url)
  # end


  # def search_blueprint_titles params
  #   gallery_handler.search_blueprint_titles params
  # end

  # def initialize(params)
  #   @url = params[:url]
  # end
  
  def blueprints
    @blueprints ||= EnginesGallery.blueprints url
  end

  def search_blueprint_titles search_string
    if search_string.nil?
      blueprints
    else
      blueprints.select{|blueprint| blueprint['full_name'].downcase.include? search_string.downcase }
    end
  end

end
