module Engines::Galleries

  class Gallery
  
    def initialize gallery_url
      @gallery_url = gallery_url
    end
  
    def softwares
      load_gallery_softwares
    end
  
    def software(software_id)
      load_gallery_software software_id
    end

    # def installer_for(software_id)
      # Engines::Applications::Installer.new(self)
    # end
#   
  private
  
    def load_gallery_softwares
      return nil if @gallery_url.blank?
      gallery_uri = URI(@gallery_url)
      return [] if (gallery_uri.host.nil? || gallery_uri.port.nil?)
      Net::HTTP.start(gallery_uri.host, gallery_uri.port) do |http|
        request = Net::HTTP::Get.new gallery_uri
        response = http.request request
        if response.code.to_i >= 200 && response.code.to_i < 400 
          return JSON.parse(response.body).map!{|software| software.symbolize_keys!}
        else
          return []
        end
      end
    end
  
    def self.load_gallery_software(software_id)
      return nil if (@gallery_url.blank? || software_id.blank?)
      blueprint_uri = URI(@gallery_url + "/" +  software_id)
      return nil if (blueprint_uri.host.nil? || blueprint_uri.port.nil?)
      Net::HTTP.start(blueprint_uri.host, blueprint_uri.port) do |http|
        blueprint_request = Net::HTTP::Get.new blueprint_uri
        blueprint_response = http.request blueprint_request
        if blueprint_response.code.to_i >= 200 && blueprint_response.code.to_i < 400
          return JSON.parse(blueprint_response.body).symbolize_keys!
        else
          return nil
        end    
      end
    end
  
  end

end
