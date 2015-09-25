class InstallersController < ApplicationController


  def show
    if gallery_id.blank?
      redirect_to galleries_path, alert: "No galleries. Add a gallery to install software." 
    else
      @gallery = Gallery.find(gallery_id)
      @other_galleries = Gallery.where.not(id: gallery_id)
      params[:tags] = ( (params[:commit] == 'All' || params[:tags].blank?) ? 'All' : params[:tags] )
    end
  end

  def gallery_id
    params[:gallery_id] || ( GallerySettings.instance.default_gallery || Gallery.first ).id
  end

end
