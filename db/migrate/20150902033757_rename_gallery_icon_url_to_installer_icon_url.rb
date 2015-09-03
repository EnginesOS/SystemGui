class RenameGalleryIconUrlToInstallerIconUrl < ActiveRecord::Migration
  def change
    rename_column :application_display_properties, :gallery_icon_url, :installer_icon_url
  end
end
