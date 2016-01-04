class Maintenance

  def self.full_maintenance
    check_default_library
    remove_orphaned_softwares
  end

  def self.check_default_library
    if Gallery.count == 0
      Gallery.create(url: "engineslibrary.engines.onl", name: "Engines Library")
    elsif Gallery.first.url != "engineslibrary.engines.onl"
      Gallery.first.update(url: "engineslibrary.engines.onl", name: "Engines Library")
    end
  end

  def self.remove_orphaned_softwares
    system_application = Application.application_container_names_list
    gui_applications = Application.all.map(&:container_name)
    orphaned_software = gui_applications - system_application
    orphaned_software.each do |orphan|
      Application.find_by(container_name: orphan).destroy
    end
  end

end
