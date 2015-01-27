class CreateDisplays < ActiveRecord::Migration
  def change
    create_table :displays do |t|
      t.integer :software_id
    end
  end
end
