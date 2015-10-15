class CreateApplicationInstallations < ActiveRecord::Migration
  def change
    create_table :application_installations do |t|
      t.integer :application_id
    end
  end
end
