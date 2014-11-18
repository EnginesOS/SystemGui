class SystemConfigsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_system_config, only: [:update, :edit_default_domain, :edit_default_website, :edit_mail, :edit_wallpaper] # , :edit

  # def new
  #   @settings = Settings.new
  # end

  def create
    @system_config = SystemConfig.new(system_config_params)

    if @system_config.save
      redirect_to system_configs_path, notice: 'Settings were successfully saved.'
    else
      redirect_to system_configs_path, alert: 'Settings were not saved.'
    end
  end

  def update
    if (@system_config.update(system_config_params) && $enginesOS_api.save_system_preferences(system_config_params))
      redirect_to settings_path, notice: 'Settings were successfully saved.'
    else
      redirect_to settings_path, alert: 'Settings were not saved.'
    end
  end


private

  def set_system_config
    @system_config = SystemConfig.first
  end

  def system_config_params
    params.require(:system_config).permit!
  end

end
