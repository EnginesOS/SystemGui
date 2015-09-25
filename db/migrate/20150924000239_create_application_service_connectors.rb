class CreateApplicationServiceConnectors < ActiveRecord::Migration
  def change
    create_table :application_service_connectors do |t|
      t.integer :application_id
    end
  end
end
