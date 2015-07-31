class AddGalleryIconUrlToApplicationDisplayProperties < ActiveRecord::Migration
  def change
    add_column :application_display_properties, :gallery_icon_url, :string
  end
end
