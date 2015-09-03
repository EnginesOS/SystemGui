class RenameDockerHubInstallation < ActiveRecord::Migration
  def change
    rename_table :docker_hub_installations, :install_from_docker_hubs
  end
end
