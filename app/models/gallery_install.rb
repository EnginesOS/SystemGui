class GalleryInstall < ActiveRecord::Base

  # def gallery_server
  #   server = nil
  #   gallery_servers = EngineGallery.list_local
  #   gallery_servers.each do |gallery_server|
  #     if name == gallery_server.short_name && url == gallery_server.gallery_url
  #       server = gallery_server
  #     end
  #   end
  #   return server
  # end

  # def title
  #   gallery_server.title
  # end


  # def self.get_unadded_gallery_servers
  #   galleries = self.all

  #   added_gallery_servers = []
  #   galleries.each do |gallery|
  #     added_gallery_servers << gallery.gallery_server
  #   end
  #   added_gallery_server_short_names = added_gallery_servers.map(&:short_name)

  #   all_gallery_servers = EngineGallery.list_local
  #   all_gallery_server_short_names = all_gallery_servers.map(&:short_name)
  #   unadded_gallery_server_short_names = all_gallery_server_short_names - added_gallery_server_short_names

  #   unadded_gallery_servers = []
  #   unadded_gallery_server_short_names.each do |unadded_gallery_server_short_name|
  #     all_gallery_servers.each do |gallery_server|
  #       if gallery_server.short_name == unadded_gallery_server_short_name
  #         unadded_gallery_servers << gallery_server
  #       end
  #     end
  #   end
  #   return unadded_gallery_servers
  # end



end
