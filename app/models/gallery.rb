class Gallery < ActiveRecord::Base

  def softwares
    @softwares ||= EnginesGallery.softwares gallery_url: url
  end

  def search_software_titles search_string
    if search_string.blank?
      softwares
    else
      softwares.select{|software| software['full_name'].downcase.include? search_string.downcase }
    end
  end

end
