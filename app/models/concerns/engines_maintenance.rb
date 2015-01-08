module EnginesMaintenance

  def self.db_maintenance
    remove_orphaned_softwares
    create_missing_softwares
    remove_duplicate_softwares if Software.count != EnginesSoftware.count
    reload_domains
  end

private

  def self.remove_duplicate_softwares
    app_installs = Software.all
    grouped_app_installs = app_installs.group_by(&:engine_name)
    grouped_app_installs.each do |softwares|
      softwares = softwares[1]
      softwares.shift
      softwares.each{|software| software.destroy}
    end
  end

  def self.remove_orphaned_softwares
    software_engines = EnginesSoftware.all_engine_names
    software = Software.all.map(&:engine_name)
    orphaned_software = software - software_engines
    orphaned_software.each do |software|
      Software.find_by(engine_name: software).destroy
    end
  end

  def self.create_missing_softwares
    software_engines = EnginesSoftware.all_engine_names
    software = Software.all.map(&:engine_name)
    missing_software = software_engines - software
    missing_software.each do |software|
      Software.create(engine_name: software).load_display_property_defaults.save
    end
  end

  def self.reload_domains
    Domain.delete_all

p :EnginesDomain_engines_domains
p EnginesDomain.engines_domains


    EnginesDomain.engines_domains.each do |domain|
p :domain
p domain      
      Domain.create(domain_name: domain)
    end
  end


  # def software_params software_engine_name
  #   software_engine = EnginesSoftware.engines_software software_engine_name
  # end


end