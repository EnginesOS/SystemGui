class CreateComponentServices < ActiveRecord::Migration
  def change
    create_table :component_services do |t|
      t.integer :component_id
    end
  end
end
