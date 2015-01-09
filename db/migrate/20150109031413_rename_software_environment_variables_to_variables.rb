class RenameSoftwareEnvironmentVariablesToVariables < ActiveRecord::Migration
  def change
    rename_table(:software_environment_variables, :variables)
  end
end
