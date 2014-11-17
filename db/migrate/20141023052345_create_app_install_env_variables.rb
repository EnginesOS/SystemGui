class CreateAppInstallEnvVariables < ActiveRecord::Migration
  def change
    create_table :app_install_env_variables do |t|
      t.integer :app_install_id
      t.string :name
      t.string :value
      t.string :comment
      t.boolean :ask_at_runtime
    end
  end
end
