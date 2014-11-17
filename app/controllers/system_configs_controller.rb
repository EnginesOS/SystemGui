class SystemConfigsController < ApplicationController
  before_action :authenticate_user!

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

  def index
    @system_config = SystemConfig.settings
  end

  def update
    @settings_config = SystemConfig.first
    if (@settings_config.update(system_config_params) && $enginesOS_api.save_system_preferences(system_config_params))
      redirect_to system_configs_path, notice: 'Settings were successfully saved.'
    else
      redirect_to system_configs_path, alert: 'Settings were not saved.'
    end
  end


private

  def system_config_params
    params.require(:system_config).permit!
  end

end
