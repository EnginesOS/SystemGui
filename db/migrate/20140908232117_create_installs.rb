class CreateInstalls < ActiveRecord::Migration
  def change
    create_table :installs do |t|
      t.string :display_name
      t.text :display_description
      t.boolean :terms_and_conditions_accepted
      t.string :gallery_server_name
      t.string :gallery_server_url
      t.string :blueprint_id
      # t.string :host_name
      # t.string :host_domain
    end
  end
end
