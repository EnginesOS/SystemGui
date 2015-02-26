module EnginesMaintenance

  extend EnginesMaintenanceSoftwares
  extend EnginesMaintenanceDomains

  def self.full_maintenance
    softwares_maintenance
p :finished_softwares_maintenance    
    domains_maintenance
p :finished_domains_maintenance
  end

end