class Gallery < ActiveRecord::Base

  validates_presence_of :url, :name

  def softwares
    @softwares ||= EnginesGallery.softwares gallery_url: url
  rescue
    @softwares = []
  end

  def search_software_titles search_string
    if search_string.blank?
      softwares
    else
      softwares.select{|software| p :hi; p software['title']; software['title'].to_s.downcase.include? search_string.to_s.downcase }
    end
  end

end
