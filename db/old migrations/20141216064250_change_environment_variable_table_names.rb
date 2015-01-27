class ChangeEnvironmentVariableTableNames < ActiveRecord::Migration
  def change
    rename_table(:environment_variables, :software_environment_variables)    
    rename_table(:environment_variable_values, :software_environment_variable_values)    
  end
end
