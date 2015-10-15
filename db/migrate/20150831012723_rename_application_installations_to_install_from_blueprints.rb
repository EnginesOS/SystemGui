class RenameApplicationInstallationsToInstallFromBlueprints < ActiveRecord::Migration
  def change
    rename_table :application_installations, :install_from_blueprints
  end
end
