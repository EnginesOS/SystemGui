class ChangeIdColumnNames < ActiveRecord::Migration
  def change
    rename_column(:environment_variable_values, :app_install_env_variable_id, :environment_variable_id)
    rename_column(:environment_variables, :app_install_id, :software_id)
  end
end
