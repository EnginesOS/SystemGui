class AddTextAlignmentAndIconSizeToDisplaySettings < ActiveRecord::Migration
  def change
    add_column :display_settings, :center_align, :boolean
    add_column :display_settings, :icon_size, :string
  end
end
