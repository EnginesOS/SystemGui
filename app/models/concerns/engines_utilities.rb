module EnginesUtilities

  def self.icon_from_url url

    return nil if url.blank?

    extname = File.extname(url)
    basename = File.basename(url, extname)

    file = Tempfile.new([basename, extname])
    file.binmode

    open(URI.parse(url)) do |data|  
      file.write data.read
    end

    file.rewind

    return file

  rescue
    return nil
  end  

end