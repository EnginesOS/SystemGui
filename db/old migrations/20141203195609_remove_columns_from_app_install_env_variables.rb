class RemoveColumnsFromAppInstallEnvVariables < ActiveRecord::Migration
  def change
    remove_column :app_install_env_variables, :name, :string
    remove_column :app_install_env_variables, :value, :string
    remove_column :app_install_env_variables, :comment, :string
    remove_column :app_install_env_variables, :ask_at_runtime, :string
  end
end
