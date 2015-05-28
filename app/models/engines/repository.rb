class Engines::Repository

  def initialize(repository_url)
    @repository_url = repository_url
  end

  def blueprint
    @blueprint ||= load_blueprint
  end

  # def software_params_from_blueprint repository_params
  #   blueprint_from_repository(repository_params)[:software]
  # end

private

  def load_blueprint
    buildname = File.basename(@repository_url)
    segments = buildname.split('.')
    buildname = segments[0]
    clone_repo buildname
    blueprint_filename =  SysConfig.DeploymentDir + "/" + buildname + "/blueprint.json"
    blueprint_json_str = File.read(blueprint_filename)
    bluePrint = JSON.parse(blueprint_json_str)
    return bluePrint.symbolize_keys!
  end

  def clone_repo(buildname)
    backup_lastbuild
    Git.clone(@repository_url, buildname, path: SysConfig.DeploymentDir)
  end

  def backup_lastbuild
    buildname = File.basename(@repository_url)
    segments = buildname.split('.')   
    buildname = segments[0]
    dir = SysConfig.DeploymentDir + "/" + buildname
    if Dir.exists?(dir)
      backup=dir + ".backup"
      if Dir.exists?(backup)
        FileUtils.rm_rf backup
      end
      FileUtils.mv(dir,backup)
    end     
  end

end