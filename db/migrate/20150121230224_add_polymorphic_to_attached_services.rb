class AddPolymorphicToAttachedServices < ActiveRecord::Migration
  def change
    add_column :attached_services, :attached_service_consumer_type, :string
    rename_column(:attached_services, :software_id, :attached_service_consumer_id)
  end
end
