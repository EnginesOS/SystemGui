class RemoveUnusedTables < ActiveRecord::Migration
  def change
    drop_table :application_installs
    drop_table :backup_properties
    drop_table :backup_tasks
    drop_table :installers
    drop_table :installer_settings
  end
end
