class ChangeSoftwareEnvVarId < ActiveRecord::Migration
  def change
    rename_column(:software_environment_variable_values, :environment_variable_id, :software_environment_variable_id)
  end
end
