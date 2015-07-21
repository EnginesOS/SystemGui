class Maintenance

  def self.full_maintenance
    if Gallery.count == 0
      Gallery.create(url: "http://enginegallery.engines.onl/api/v0/software", name: "Engines Library")
    elsif Gallery.first.url != "http://enginegallery.engines.onl/api/v0/software"
      Gallery.first.update(url: "http://enginegallery.engines.onl/api/v0/software", name: "Engines Library")
    end
  end

end