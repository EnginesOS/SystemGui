class CreateSettingsConfigs < ActiveRecord::Migration
  def change
    create_table :settings_configs do |t|
      t.string :default_domain
      t.string :default_site
      t.string :smtp_smarthost
      t.attachment :wallpaper
    end
  end
end
