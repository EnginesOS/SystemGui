class Maintenance

  def self.full_maintenance
    if User.count == 0
      User.create(email: 'noreply@engines.onl', username: 'admin', password: 'EngOS2014', password_confirmation: 'EngOS2014')
    end
    if Gallery.count == 0
      Gallery.create(url: "http://enginegallery.engines.onl/api/v0/software", name: "Engines Library")
    elsif Gallery.first.url != "http://enginegallery.engines.onl/api/v0/software"
      Gallery.first.update(url: "http://enginegallery.engines.onl/api/v0/software", name: "Engines Library")
    end
  end

end