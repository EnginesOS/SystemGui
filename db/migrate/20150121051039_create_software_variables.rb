class CreateSoftwareVariables < ActiveRecord::Migration
  def change
    create_table :software_variables do |t|
      t.integer :software_id
    end
  end
end
