class Maintenance

  def self.full_maintenance
    if Gallery.count == 0
      Gallery.create(url: "enginegallery.engines.onl", name: "Engines Library")
    elsif Gallery.first.url != "enginegallery.engines.onl"
      Gallery.first.update(url: "enginegallery.engines.onl", name: "Engines Library")
    end
  end

end