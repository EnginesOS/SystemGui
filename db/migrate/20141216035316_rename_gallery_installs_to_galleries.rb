class RenameGalleryInstallsToGalleries < ActiveRecord::Migration
  def change
    rename_table(:gallery_installs, :galleries)    
  end
end
