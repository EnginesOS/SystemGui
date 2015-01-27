class RenameAppInstallsToSoftwares < ActiveRecord::Migration
  def change
    rename_table(:app_installs, :softwares)    
  end
end
