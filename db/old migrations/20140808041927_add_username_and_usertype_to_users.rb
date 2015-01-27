class AddUsernameAndUsertypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true
    add_column :users, :user_type, :string
  end
end
