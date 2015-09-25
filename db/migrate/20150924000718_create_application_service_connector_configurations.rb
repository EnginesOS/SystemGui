class CreateApplicationServiceConnectorConfigurations < ActiveRecord::Migration
  def change
    create_table :application_service_connector_configurations do |t|
      t.integer :application_service_connector_id
    end
  end
end
