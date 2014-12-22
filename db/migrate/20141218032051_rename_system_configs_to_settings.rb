class RenameSystemConfigsToSettings < ActiveRecord::Migration
  def change
    rename_table(:system_configs, :settings)
  end
end
