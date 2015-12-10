class RenameDesktopSettingsToDisplaySettings < ActiveRecord::Migration
  def change
    rename_table :desktop_settings, :display_settings
  end
end
