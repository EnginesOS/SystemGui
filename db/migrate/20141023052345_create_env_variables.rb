class CreateEnvVariables < ActiveRecord::Migration
  def change
    create_table :env_variables do |t|
      t.integer :install_id
      t.string :name
      t.string :value
      t.boolean :set_at_runtime
    end
  end
end
