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

p :software_engines
p software_engines

    softwares = Software.all.map(&:engine_name)

p :software
p softwares


    missing_software = software_engines - softwares
    missing_software.each do |software|
      software = Software.create(engine_name: software)
      software.load_display_property_defaults
      result = software.save
p :result_on_create_missing_software
p software
p result
p software.errors

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