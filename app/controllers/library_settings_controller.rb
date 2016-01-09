class LibrarySettingsController < ApplicationController

  before_action :set_library_settings

  def edit
  end

  def update
    if @library_settings.update(library_settings_params)
      redirect_to libraries_path, notice: "Successfully updated library settings."
    else
      render :edit
    end
  end
    

private

  def set_library_settings
    @library_settings = LibrarySettings.instance
  end

  def library_settings_params
    @library_settings_params ||= params.require(:library_settings).permit!
  end
  
end
