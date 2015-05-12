class InstallersController < ApplicationController

  before_action :authenticate_user!

  def show
    if gallery_id.blank?
      redirect_to galleries_path, alert: "No galleries. Add a gallery to install software." 
    else
      @gallery = Gallery.find(gallery_id).decorate
      @other_galleries = Gallery.where.not(id: gallery_id)
    end
  end

  def gallery_id
    params[:gallery_id] || ( GallerySettings.instance.default_gallery || Gallery.first ).id
  end

end
