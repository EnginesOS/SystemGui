class DesktopSettingsController < ApplicationController

  before_action :set_desktop_settings

  def edit
    # DesktopSettings.delete_all
    # set_desktop_settings
    # @desktop_settings.delete
  end

  def update
    if @desktop_settings.update desktop_settings_params
      redirect_to desktop_path, notice: "Successfully updated desktop settings."
    else
      render :edit
    end
  end

private

  def set_desktop_settings
    @desktop_settings = DesktopSettings.instance
  end

  def desktop_settings_params
    @desktop_settings_params ||= params.require(:desktop_settings).permit!
  end
  
end
