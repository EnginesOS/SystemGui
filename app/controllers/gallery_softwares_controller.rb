class GallerySoftwaresController < ApplicationController
  before_action :authenticate_user!

  def show
    @gallery = Gallery.find(params[:gallery_id])
    # render text: @gallery.methods.sort
    @softwares = @gallery.search_software_titles(params[:search]).sort_by{|b| b[:title] }
    render layout: false
  end

end
