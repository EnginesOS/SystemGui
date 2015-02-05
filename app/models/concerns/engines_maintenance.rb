module EnginesMaintenance

  extend EnginesMaintenanceSoftwares
  extend EnginesMaintenanceDomains

  def self.db_maintenance
    softwares_maintenance
    domains_maintenance
  end

end