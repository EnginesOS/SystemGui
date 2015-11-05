class InstallersController < ApplicationController

  def show
    if DomainSettings.engines_default_domain.empty? || DomainSettings.engines_default_domain == 'unset'
      redirect_to control_panel_path, alert: "Please set a default domain before installing software." 
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
