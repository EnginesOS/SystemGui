class Maintenance

  def self.full_maintenance
    check_default_library
    remove_orphaned_softwares
  end

  def self.check_default_library
    if Library.count == 0
      Library.create(url: "engineslibrary.engines.onl", name: "Engines Library")
    elsif Library.first.url != "engineslibrary.engines.onl"
      Library.first.update(url: "engineslibrary.engines.onl", name: "Engines Library")
    end
    LibrarySettings.instance.update(default_library_id: 1) if deafult_library_id_invalid
  end

  def self.deafult_library_id_invalid
    Library.where(id: LibrarySettings.instance.default_library_id).empty?
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
