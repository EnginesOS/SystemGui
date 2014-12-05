class AddBackgroundColorToSystemConfigs < ActiveRecord::Migration
  def change
    add_column :system_configs, :background_color, :string
  end
end
