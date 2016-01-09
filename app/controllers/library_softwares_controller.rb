class LibrarySoftwaresController < ApplicationController

  class PaginatedSoftwares
    attr_accessor :total_pages, :softwares, :current_page, :limit_value

    def initialize(library_softwares_hash)
      library_softwares_hash = library_softwares_hash.symbolize_keys
      @softwares = library_softwares_hash[:softwares].map(&:symbolize_keys)
      @total_pages = library_softwares_hash[:total_pages].to_i
      @current_page = (library_softwares_hash[:page].present? ? library_softwares_hash[:page].to_i : 1)
    end

  end
    
  def show
    @library = Library.find(params[:library_id])
    softwares_params = { search: params[:search], tags: params[:tags], page: params[:page], per_page: 8 }
    softwares = @library.softwares softwares_params
    @paginated_softwares = PaginatedSoftwares.new(softwares)
    render layout: false
  end
  
  def tags_list
    @library = Library.find(params[:library_id])
    render partial: true
  end

end
