class RenameAppInstallEnvVariablesToEnvironmentVariables < ActiveRecord::Migration
  def change
    rename_table(:app_install_env_variables, :environment_variables)
  end
end
