class SystemConfigsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_system_config, only: [:update, :edit_default_domain, :edit_default_website, :edit_mail, :edit_wallpaper]

  def update
    if (@system_config.update(system_config_params) && EnginesApiHandler.engines_api.save_system_preferences(system_config_params))
      redirect_to settings_path, notice: 'Settings were successfully saved.'
    else
      redirect_to settings_path, alert: 'Settings were not saved.'
    end
  end

private

  def set_system_config
    @system_config = SystemConfig.settings
  end

  def system_config_params
    allow_form_to_have_no_system_config_id
    params.require(:system_config).permit!
  end

  def allow_form_to_have_no_system_config_id
    if params[:system_config].nil?
      params[:system_config] = {id: SystemConfig.first.id}
    end
  end

end
