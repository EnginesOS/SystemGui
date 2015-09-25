class GallerySettingsController < ApplicationController

  before_action :set_gallery_settings

  def edit
  end

  def update
    if @gallery_settings.update(gallery_settings_params)
      redirect_to galleries_path, notice: "Successfully updated gallery settings."
    else
      render :edit
    end
  end
    

private

  def set_gallery_settings
    @gallery_settings = GallerySettings.instance
  end

  def gallery_settings_params
    @gallery_settings_params ||= params.require(:gallery_settings).permit!
  end
  
end
