class RenameRuntimesToResources < ActiveRecord::Migration
  def change
    rename_table(:runtimes, :resources)
  end
end
