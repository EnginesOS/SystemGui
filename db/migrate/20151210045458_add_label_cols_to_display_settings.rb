class AddLabelColsToDisplaySettings < ActiveRecord::Migration
  def change
    add_column :display_settings, :system_label, :string
    add_column :display_settings, :show_label, :boolean
  end
end
