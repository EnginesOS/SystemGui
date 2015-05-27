class GalleriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @gallery_settings = GallerySettings.instance
    @galleries = Gallery.all
    # @unadded_gallery_servers = GalleryInstall.get_unadded_gallery_servers
  end

  def new
    @gallery = Gallery.new
  end

  def edit
    @gallery = Gallery.find(params[:id])
  end

  def update
    @gallery = Gallery.find(params[:id])
    @gallery.update(gallery_install_params)
    redirect_to galleries_path
  end

  def create
    @gallery = Gallery.new(gallery_install_params)
    if @gallery.save
      redirect_to galleries_path
    else
      render :new
    end
  end

  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy
    redirect_to galleries_path
  end

private

  def gallery_install_params
    params.require(:gallery).permit!
  end

end
