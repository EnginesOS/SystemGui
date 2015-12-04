class Maintenance

  def self.full_maintenance
    if Gallery.count == 0
      Gallery.create(url: "engineslibrary.engines.onl", name: "Engines Library")
    elsif Gallery.first.url != "engineslibrary.engines.onl"
      Gallery.first.update(url: "engineslibrary.engines.onl", name: "Engines Library")
    end
  end

end
