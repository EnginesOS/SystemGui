module EnginesUtilities

  def self.icon_from_url url
  if url.present?
      begin
        begin
          @icon = URI.parse(url)
        rescue Exception=>e
          nil
        end
      rescue
        nil
      end
    end
  end  

end