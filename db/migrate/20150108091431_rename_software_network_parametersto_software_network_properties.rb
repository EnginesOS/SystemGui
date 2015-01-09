class RenameSoftwareNetworkParameterstoSoftwareNetworkProperties < ActiveRecord::Migration
  def change
    rename_table(:software_network_parameters, :software_network_properties)
  end
end
