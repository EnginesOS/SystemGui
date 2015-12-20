class AddIconAndSigninToggleDisplaySettings < ActiveRecord::Migration
  def change
    add_attachment :display_settings, :icon
    add_column :display_settings, :show_desktop_signin, :boolean
  end
end
