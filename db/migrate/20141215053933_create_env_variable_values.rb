class CreateEnvVariableValues < ActiveRecord::Migration
  def change
    create_table :env_variable_values do |t|
      t.integer :app_install_env_variable_id
    end
  end
end
