class Engines::Repository

  require 'net/http'

  def initialize(url)
    @url = url
  end

  def blueprint
    @blueprint ||= if is_git_repo?
                     load_blueprint_from_git
                   else
                     load_blueprint_with_http_get
                   end
  end

private

  def is_git_repo?
    Git.ls_remote(@url).present?
  rescue
    false
  end
  
  def load_blueprint_with_http_get
    url = URI.parse(@url)
    
p :url
p url

    request = Net::HTTP::Get.new(url.to_s)
    result = Net::HTTP.start(url.host, url.port) {|http|
      http.request(request)
    }
    JSON.parse(result.body).symbolize_keys!
  end

  def load_blueprint_from_git
    buildname = File.basename(@url)
    segments = buildname.split('.')
    buildname = segments[0]
    clone_repo buildname
    blueprint_filename =  SystemConfig.DeploymentDir + "/" + buildname + "/blueprint.json"
    blueprint_json_str = File.read(blueprint_filename)
    bluePrint = JSON.parse(blueprint_json_str)
    return bluePrint.symbolize_keys!
  rescue Exception => e
    SystemUtils.log_exception(e)
  end

  def clone_repo(buildname)
    backup_lastbuild
    Git.clone(@url, buildname, path: SystemConfig.DeploymentDir, depth: 1)
  end

  def backup_lastbuild
    buildname = File.basename(@url)
    segments = buildname.split('.')   
    buildname = segments[0]
    dir = SystemConfig.DeploymentDir + "/" + buildname
    if Dir.exists?(dir)
      backup=dir + ".backup"
      if Dir.exists?(backup)
        FileUtils.rm_rf backup
      end
      FileUtils.mv(dir,backup)
    end     
  end

end