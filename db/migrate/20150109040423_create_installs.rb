class CreateInstalls < ActiveRecord::Migration
  def change
    create_table :installs do |t|
      t.integer :software_id
    end
  end
end
