class ExtendDisplaySettings < ActiveRecord::Migration
  def change
    remove_column :display_settings, :show_label
    add_column :display_settings, :desktop_header, :text
    add_column :display_settings, :desktop_footer, :text
    add_column :display_settings, :system_title, :string
  end
end
