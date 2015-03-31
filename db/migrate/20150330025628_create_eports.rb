class CreateEports < ActiveRecord::Migration
  def change
    create_table :eports do |t|
      t.integer :software_id
    end
  end
end
