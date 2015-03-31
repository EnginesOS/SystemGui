class CreateBackupTasksTables < ActiveRecord::Migration
  def change
    create_table :backup_tasks_handlers do |t|
      t.integer :software_id
    end

    create_table :backup_tasks do |t|
      t.integer :backup_tasks_handler_id
    end

  end
end
