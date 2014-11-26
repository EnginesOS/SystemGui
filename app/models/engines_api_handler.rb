module EnginesApiHandler

  require "/opt/engines/lib/ruby/EnginesOSapi.rb"

  def self.engines_api
    if $enginesOS_api == nil
      $enginesOS_api = EnginesOSapi.new
    end
    return $enginesOS_api
  end

  



  def self.db_maintenance
    remove_dupes
    remove_orphaned_records
  end

  def self.remove_orphaned_records
    app_engine_names = AppHandler.all.map(&:engine_name)
    app_install_engine_names = AppInstall.all.map(&:engine_name)
    orphaned_app_installs = app_install_engine_names - app_engine_names
    orphaned_app_installs.each do |orphaned_app_install_engine_name|
      AppInstall.find_by_engine_name(orphaned_app_install_engine_name).destroy
    end
  end

  def self.remove_dupes
    app_installs = AppInstall.all
    grouped_app_installs = app_installs.group_by(&:engine_name)
    grouped_app_installs.each do |group|
      group = group[1]
      group.shift
      group.each{|app| app.destroy}
    end
  end

end

