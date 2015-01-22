class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.integer :software_id
    end
  end
end
