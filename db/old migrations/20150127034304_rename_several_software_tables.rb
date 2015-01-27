class RenameSeveralSoftwareTables < ActiveRecord::Migration
  def change
    rename_table(:software_variables, :software_variables_handlers)
    create_table :attached_services_handlers do |t|
      t.integer :software_id
    end
    rename_column(:attached_services, :software_id, :attached_services_handler_id)
  end
end
