class SettingsConfigsController < ApplicationController
  before_action :authenticate_user!

  # def new
  #   @settings = Settings.new
  # end

  # def create
  #   @settings = Settings.new(settings_params)

  #   if @settings.save
  #     redirect_to settings_path, notice: 'Settings were successfully saved.'
  #   else
  #     redirect_to settings_path, alert: 'Settings were not saved.'
  #   end
  # end

  def update
    @settings_config = SettingsConfig.first || SettingsConfig.new
p params
    if @settings_config.update(settings_params)
      $enginesOS_api.save_system_preferences settings_params
      redirect_to settings_path, notice: 'Settings were successfully saved.'
    else
      redirect_to settings_path, alert: 'Settings were not saved.'
    end
  end


private

  def settings_params
    params.require(:settings_config).permit!
  end

end
