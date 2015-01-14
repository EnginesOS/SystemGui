module EnginesMaintenance

  def self.db_maintenance
    remove_nameless_softwares
    remove_orphaned_softwares
    create_missing_softwares
    remove_duplicate_softwares if Software.count != EnginesSoftware.count
    reload_domains
  end

private

  def self.remove_nameless_softwares
    nameless_software = Software.all.select{|software| software.engine_name == nil}
    nameless_software.each{|software| software.destroy}
  end

  def self.remove_duplicate_softwares
    software = Software.all
    grouped_software = software.group_by(&:engine_name)
    grouped_software.each do |softwares|
      softwares = softwares[1]
      softwares.shift
      softwares.each{|software| software.destroy}
    end
  end

  def self.remove_orphaned_softwares
    software_engines = EnginesSoftware.all_engine_names
    softwares = Software.all.map(&:engine_name)
    orphaned_software = softwares - software_engines
    orphaned_software.each do |software|
      p :software
      p software
      # Software.find_by(engine_name: software).destroy
    end
  end

  def self.create_missing_softwares
    software_engines = EnginesSoftware.all_engine_names
    softwares = Software.all.map(&:engine_name)
    missing_software = software_engines - softwares
    missing_software.each do |software_name|
      software = Software.create(engine_name: software_name, display_attributes: (Display.engine_display_properties_from_api(software_name)) )
      url = Display.engine_icon_url_from_api(software_name)

      software.display.icon = EnginesUtilities.icon_from_url(url)
      software.save
    end
  end

  def self.reload_domains
    Domain.delete_all
    EnginesDomain.engines_domains.each do |domain|
    Domain.create(domain_name: domain)
    end
  end

end