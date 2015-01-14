module EnginesUtilities

  def self.icon_from_url url

p :downloading_image_from_url
p url

    if url.present?
      begin



        @icon = URI.parse(url)


      rescue Exception=>e

p :nok
p e      

        nil
      end
    end  
  end  

end