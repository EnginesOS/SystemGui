class RenameComponentsToAttachedServices < ActiveRecord::Migration
  def change
    rename_table(:components, :attached_services)
  end
end
