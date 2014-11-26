class GalleryBlueprintHandler

  attr_accessor :blueprint_id
  attr_accessor :gallery_url
  attr_accessor :app_install_created_from_existing_engine

  def initialize opts
    @blueprint_id = opts[:blueprint_id]
    @gallery_url = opts[:gallery_url]
  end

  def software
    blueprint['software']
  end

  def repository
    blueprint_entry["repository"]
  end

private

  def gallery
    GalleryHandler.new url: gallery_url
    # GalleryHandler.get_gallery @gallery_server_name, @gallery_url
  end

  def blueprint
    buildname = File.basename(repository)
    segments = buildname.split('.')
    buildname = segments[0]
    clone_repo(repository,buildname)
    blueprint_filename =  SysConfig.DeploymentDir + "/" + buildname + "/blueprint.json"
    blueprint_file = File.open(blueprint_filename,"r")
    blueprint_json_str = blueprint_file.read
    blueprint_file.close 
    bluePrint = JSON.parse(blueprint_json_str)
    return bluePrint
  end

  def blueprint_entry
    blueprint_uri = URI(gallery_url + "/" +  blueprint_id)
    Net::HTTP.start(blueprint_uri.host, blueprint_uri.port) do |http|
      blueprint_request = Net::HTTP::Get.new blueprint_uri
      blueprint_response = http.request blueprint_request # Net::HTTPResponse object
      if blueprint_response.code.to_i >= 200 && blueprint_response.code.to_i < 400
        return JSON.parse(blueprint_response.body)
      else
        return nil #FIXME should put error mesg somewhere
      end    
    end
  end
           
  def clone_repo(repo, buildname)
    backup_lastbuild repo
    g = Git.clone(repo, buildname, :path => SysConfig.DeploymentDir)
  end

  def backup_lastbuild repo
    buildname = File.basename(repo)
    segments = buildname.split('.')   
    buildname = segments[0]
    dir=SysConfig.DeploymentDir + "/" + buildname
    if Dir.exists?(dir)
      backup=dir + ".backup"
      if Dir.exists?(backup)
        FileUtils.rm_rf backup
      end
      FileUtils.mv(dir,backup)
    end     
  end

end