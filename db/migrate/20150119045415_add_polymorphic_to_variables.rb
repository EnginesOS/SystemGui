class AddPolymorphicToVariables < ActiveRecord::Migration
  def change
    add_column :variables, :variable_consumer_type, :string
    rename_column(:variables, :software_id, :variable_consumer_id)
  end
end
