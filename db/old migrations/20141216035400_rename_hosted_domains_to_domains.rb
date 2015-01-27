class RenameHostedDomainsToDomains < ActiveRecord::Migration
  def change
    rename_table(:hosted_domains, :domains)    
  end
end
