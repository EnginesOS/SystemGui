class MoveDisplayAttributeFromSoftwaresToDisplay < ActiveRecord::Migration
  def change
    remove_column :softwares, :display_name, :string
    remove_column :softwares, :display_description, :text
    remove_column :softwares, :icon_file_name, :string
    remove_column :softwares, :icon_content_type, :string
    remove_column :softwares, :icon_file_size, :integer
    remove_column :softwares, :icon_updated_at, :string
    add_column :displays, :display_name, :string
    add_column :displays, :display_description, :text
    add_column :displays, :icon_file_name, :string
    add_column :displays, :icon_content_type, :string
    add_column :displays, :icon_file_size, :integer
    add_column :displays, :icon_updated_at, :string
  end
end
