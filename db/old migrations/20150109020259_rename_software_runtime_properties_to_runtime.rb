class RenameSoftwareRuntimePropertiesToRuntime < ActiveRecord::Migration
  def change
    rename_table(:software_runtime_properties, :runtimes)
  end
end
