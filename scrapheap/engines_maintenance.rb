module EnginesMaintenance

  extend EnginesMaintenanceSoftwares
  extend EnginesMaintenanceDomains

  def self.full_maintenance
    softwares_maintenance
    domains_maintenance
  end

end