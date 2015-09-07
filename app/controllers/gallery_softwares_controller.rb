class GallerySoftwaresController < ApplicationController
  before_action :authenticate_user!

  class PaginatedSoftwares
    attr_accessor :total_pages, :softwares, :current_page, :limit_value

    def initialize(gallery_softwares_hash)
      gallery_softwares_hash = gallery_softwares_hash.symbolize_keys
      @softwares = gallery_softwares_hash[:softwares].map(&:symbolize_keys)
      @total_pages = gallery_softwares_hash[:total_pages].to_i
      @current_page = (gallery_softwares_hash[:page].present? ? gallery_softwares_hash[:page].to_i : 1)
    end

  end
    
  def show
    @gallery = Gallery.find(params[:gallery_id])
    softwares_params = { search: params[:search], tags: params[:tags], page: params[:page], per_page: 8 }
    
    
p :softwares_params
p softwares_params    
    
    
    softwares = @gallery.softwares softwares_params
    @paginated_softwares = PaginatedSoftwares.new(softwares)
    render layout: false
  end
  
  def tags_list
    @gallery = Gallery.find(params[:gallery_id])
    render partial: true
  end

end
