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
      softwares.select{|software| software['full_name'].downcase.include? search_string.downcase }
    end
  end

end
