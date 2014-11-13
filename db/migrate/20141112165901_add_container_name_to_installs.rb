class AddContainerNameToInstalls < ActiveRecord::Migration
  def change
    add_column :installs, :container_name, :string
  end
end
