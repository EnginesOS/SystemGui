class AddIconTextColorToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :icon_text_color, :string
  end
end
