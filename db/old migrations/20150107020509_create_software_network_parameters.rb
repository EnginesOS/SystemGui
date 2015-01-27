class CreateSoftwareNetworkParameters < ActiveRecord::Migration
  def change
    create_table :software_network_parameters do |t|
      t.integer :software_id
    end
  end
end
