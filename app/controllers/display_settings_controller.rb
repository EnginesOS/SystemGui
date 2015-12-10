class DisplaySettingsController < ApplicationController

  before_action :set_display_settings

  def edit
    # DisplaySetting.delete_all
    # set_display_settings
    # @display_settings.delete
  end

  def update
    if @display_settings.update display_settings_params
      redirect_to system_path, notice: "Successfully updated display settings."
    else
      render :edit
    end
  end

private

  def display_settings_params
    @display_settings_params ||= params.require(:display_settings).permit!
  end

end
