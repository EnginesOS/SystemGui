class Gallery < ActiveRecord::Base

  def gallery_server
    server = nil
    gallery_servers = EngineGallery.list_local
    gallery_servers.each do |gallery_server|
      if name == gallery_server.short_name && url == gallery_server.gallery_url
        server = gallery_server
      end
    end
    return server
  end

  def title
    gallery_server.title
  end

end
