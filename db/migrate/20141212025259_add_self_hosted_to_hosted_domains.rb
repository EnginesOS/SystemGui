class AddSelfHostedToHostedDomains < ActiveRecord::Migration
  def change
    add_column :hosted_domains, :self_hosted, :boolean
  end
end
