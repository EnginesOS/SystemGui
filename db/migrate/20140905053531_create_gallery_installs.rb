class CreateGalleryInstalls < ActiveRecord::Migration
  def change
    create_table :gallery_installs do |t|
      t.string :url
      t.string :name

      t.timestamps
    end
  end
end
