class CreateAppInstalls < ActiveRecord::Migration
  def change
    create_table :app_installs do |t|
      t.string     :host_name
      t.string     :domain_name
      t.string     :engine_name
      t.string     :display_name
      t.text       :display_description
      t.string     :gallery_server_name
      t.string     :gallery_server_url
      t.string     :blueprint_id
      t.string     :license_name
      t.string     :license_sourceurl
      t.boolean    :terms_and_conditions_accepted
      t.string     :image_url
      t.attachment :icon

      t.timestamps
    end
  end
end