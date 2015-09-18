class SettingsController < ApplicationController
  before_action :set_settings, only: [:index, :update, :edit_default_domain, :edit_default_website, :edit_mail, :edit_wallpaper]

  def index
    @users = User.all
    @backup_tasks = BackupTask.all
    @galleries = Gallery.all
    @domains = Domain.all
  end

  def update
    if (@settings.update(settings_params) && @settings.update_engines(settings_params))
      redirect_to control_panel_path, notice: 'Settings were successfully saved.'
    else
      redirect_to control_panel_path, alert: 'Settings were not saved.'
    end
  end

private

  def set_settings
    @settings = Setting.first_or_create
  end

  def settings_params
    params.require(:setting).permit!
  end

end
