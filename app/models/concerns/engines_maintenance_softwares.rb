module EnginesMaintenanceSoftwares

  def softwares_maintenance
    remove_nameless_softwares
    remove_orphaned_softwares
    create_missing_softwares
    remove_duplicate_softwares if Software.count != EnginesSoftware.count
  end

private

  def remove_nameless_softwares
    nameless_softwares = Software.all.select{|software| software.engine_name.blank?}
    nameless_softwares.each{|software| software.destroy}
  end

  def remove_duplicate_softwares
    software = Software.all
    grouped_softwares = software.group_by(&:engine_name)
    grouped_softwares.each do |softwares|
      softwares = softwares[1]
      softwares.shift
      softwares.each{|dupe_software| dupe_software.destroy}
    end
  end

  def remove_orphaned_softwares
    software_engines = EnginesSoftware.all_engine_names
    softwares = Software.all.map(&:engine_name)
    orphaned_softwares = softwares - software_engines
    orphaned_softwares.each do |software|
      Software.find_by(engine_name: software).destroy
    end
  end

  def create_missing_softwares
    software_engines = EnginesSoftware.all_engine_names
    softwares = Software.all.map(&:engine_name)
    missing_softwares = software_engines - softwares

p :missing_softwares
p missing_softwares


    missing_softwares.each do |software_name|
      software = Software.create(engine_name: software_name, display_attributes: (Display.engine_display_properties_from_api(software_name)) )
      # url = Display.engine_icon_url_from_api(software_name)
      # software.display.icon = EnginesUtilities.icon_from_url(url)
      software.save
    end
  end

end