class RenameComponentServicesToAttachedSubservices < ActiveRecord::Migration
  def change
    rename_table(:component_services, :attached_subservices)
    rename_column(:attached_subservices, :component_id, :attached_service_id)
  end
end
