class CreateSystemDataCache < ActiveRecord::Migration
  def change
    create_table :system_data_caches do |t|
      t.boolean :failed_build_flag
      t.text :memory_statistics
      t.text :system_update_status
    end
  end
end
