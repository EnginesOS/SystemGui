class CreateSoftwareRuntimeProperties < ActiveRecord::Migration
  def change
    create_table :software_runtime_properties do |t|
      t.integer :software_id
    end
  end
end
