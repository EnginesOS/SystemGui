class Gallery < ActiveRecord::Base

  def gallery_server
    server = []
    gallery_servers = EngineGallery.list_local
    gallery_servers.each do |gallery_server|
    gallery_server_url = gallery_server.short_name + "." + gallery_server.gallery_url
      if gallery_server_url == url
        server = gallery_server
      end
    end
    server
  end

  def title
    gallery_server.title
  end

end
