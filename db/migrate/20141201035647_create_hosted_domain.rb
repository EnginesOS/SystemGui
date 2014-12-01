class CreateHostedDomain < ActiveRecord::Migration
  def change
    create_table :hosted_domains do |t|
      t.string :domain_name
      t.boolean :internal_only
      t.integer :system_config_id
    end
  end
end
