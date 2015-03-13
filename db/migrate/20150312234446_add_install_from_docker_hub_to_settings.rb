class AddInstallFromDockerHubToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :install_from_docker_hub, :boolean
  end
end
