class RenameEnvVariableValuesToEnvironmentVariableValues < ActiveRecord::Migration
  def change
    rename_table(:env_variable_values, :environment_variable_values)
  end
end
