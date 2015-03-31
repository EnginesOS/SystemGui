class CreateDockerHubInstalls < ActiveRecord::Migration
  def change
    create_table :docker_hub_installs do |t|
      t.integer :software_id
    end
  end
end
