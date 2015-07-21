class RedefinePropertiesTables < ActiveRecord::Migration
  def change
    rename_table :services_properties, :application_services_properties
    rename_table :variables_properties, :application_variables_properties
    rename_table :display_properties, :application_display_properties
    rename_table :network_properties, :application_network_properties
    rename_table :resources_properties, :application_resources_properties
  end
end
