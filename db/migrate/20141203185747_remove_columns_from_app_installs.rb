class RemoveColumnsFromAppInstalls < ActiveRecord::Migration
  def change
    remove_column :app_installs, :host_name, :string
    remove_column :app_installs, :domain_name, :string
    remove_column :app_installs, :gallery_url, :string
    remove_column :app_installs, :blueprint_id, :string
    remove_column :app_installs, :license_name, :string
    remove_column :app_installs, :license_sourceurl, :string
    remove_column :app_installs, :terms_and_conditions_accepted, :boolean
    remove_column :app_installs, :image_url, :string
  end
end
