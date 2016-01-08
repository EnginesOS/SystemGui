class RenameGalleriesToLibraries < ActiveRecord::Migration
  def change
    rename_table :galleries, :libraries
    rename_table :gallery_settings, :library_settings
    rename_column :library_settings, :default_gallery_id, :default_library_id
  end
end
