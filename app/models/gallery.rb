class Gallery < ActiveRecord::Base

  validate :url, :name, presence: true

  # def self.all
    # super.sort_by{|d| d.name}
  # end
  
  def destroy
    super if id != first
  end
    
  def self.all_sorted
    all.sort_by{|d| d.name}
  end

  def self.gallery_names
    all_sorted.map(&:name)
  end

  def softwares
    @softwares ||= load_gallery_softwares
  end

  def search_software_titles search_string
    if search_string.blank?
      softwares
    else
      softwares.select{|software| software[:title].to_s.downcase.include? search_string.to_s.downcase }
    end
  end

private

  def load_gallery_softwares
    gallery_uri = URI(url)
    return [] if (gallery_uri.host.nil? || gallery_uri.port.nil?)
    Net::HTTP.start(gallery_uri.host, gallery_uri.port) do |http|
      request = Net::HTTP::Get.new gallery_uri
      response = http.request request
      if response.code.to_i >= 200 && response.code.to_i < 400 
        JSON.parse(response.body).map(&:symbolize_keys)
      else
        []
      end
    end
  end
  
end
