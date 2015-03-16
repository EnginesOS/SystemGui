module EnginesMaintenanceDomains

  def domains_maintenance
    remove_nameless_domains
    remove_orphaned_domains
    create_missing_domains
    remove_duplicate_domains if Domain.count != EnginesDomain.count
  end

private

  def remove_nameless_domains
    nameless_domains = Domain.all.select{|domain| domain.domain_name.blank?}
    nameless_domains.each{|domain| domain.destroy}
  end

  def remove_duplicate_domains
    domain = Domain.all
    grouped_domains = domain.group_by(&:domain_name)
    grouped_domains.each do |domains|
      domains = domains[1]
      domains.shift
      domains.each{|dupe_domain| dupe_domain.destroy}
    end
  end

  def remove_orphaned_domains
    domains_from_engines_system = EnginesDomain.all_domain_names
    domains = Domain.all.map(&:domain_name)
    orphaned_domains = domains - domains_from_engines_system
    orphaned_domains.each do |domain|
      Domain.find_by(domain_name: domain).destroy
    end
  end

  def create_missing_domains
    domains_from_engines_system = EnginesDomain.all_domain_names
    domains = Domain.all.map(&:domain_name)
    missing_domains = domains_from_engines_system - domains
    missing_domains.each do |domain_name|
      internal_only = EnginesDomain.domain_names_hash[domain_name][:internal_only]
      self_hosted = EnginesDomain.domain_names_hash[domain_name][:self_hosted]
      domain = Domain.create(domain_name: domain_name, internal_only: internal_only, self_hosted: self_hosted )
    end
  end

end