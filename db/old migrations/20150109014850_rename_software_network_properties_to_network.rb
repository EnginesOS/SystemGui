class RenameSoftwareNetworkPropertiesToNetwork < ActiveRecord::Migration
  def change
    rename_table(:software_network_properties, :networks)
  end
end
