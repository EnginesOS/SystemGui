class DropApplicationInstallations < ActiveRecord::Migration
  def change
    drop_table :application_installations
  end
end
