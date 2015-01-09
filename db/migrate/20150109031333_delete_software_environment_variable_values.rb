class DeleteSoftwareEnvironmentVariableValues < ActiveRecord::Migration
  def change
    drop_table :software_environment_variable_values
  end
end
