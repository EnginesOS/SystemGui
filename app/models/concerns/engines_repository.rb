module EnginesRepository

  def self.repository repository_params
    load_blueprint repository_params[:repository_url]
  end

  def self.software_params repository_params
    repository(repository_params)[:software]
  end

private

  def self.load_blueprint repository_url
    buildname = File.basename(repository_url)
    segments = buildname.split('.')
    buildname = segments[0]
    clone_repo(repository_url,buildname)
    blueprint_filename =  SysConfig.DeploymentDir + "/" + buildname + "/blueprint.json"
    blueprint_json_str = File.read(blueprint_filename)
    bluePrint = JSON.parse(blueprint_json_str)
    return bluePrint.symbolize_keys!
  end

  def self.clone_repo(repo, buildname)
    backup_lastbuild repo
    Git.clone(repo, buildname, path: SysConfig.DeploymentDir)
  end

  def self.backup_lastbuild repo
    buildname = File.basename(repo)
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