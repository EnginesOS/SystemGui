require 'GalleryMaintainer.rb'
require "/opt/engos/lib/ruby/SysConfig.rb"

class EngineGallery
  
  #Galleries are to be drawn in from several sources
  #local  Yaml files  for custom galleries
  #an array of yaml files from a gallery list server for public galleries which are drawn from yaml files on disk

  def gallery_url
    return @gallery_url
  end

  def title
    return @title
  end 
  
  def short_name
    return @short_name
  end
  
  def blueprints_url
    return @blueprints_url
  end
  
  def licence_type
    return @licence_type    
  end
  
  def maintainer
    return @maintainer
  end
  
  def initialize(short_name,title,url,licence,description,maintainer)
      @title = title
      @short_name = short_name
      @blueprints_url = url
      @licence_type = licence #Free | Non Commercial use | Commercial |mixture
      @maintainer =  maintainer
      @gallery_url = local
    end
  
def self.from_yaml( yaml )
      engineGallery = YAML::load( yaml )
      enginegallery
end
    
def EngineGallery.getGallery(gallery_name,gallery_url)
  p gallery_url
  p gallery_name
  
  if gallery_url == "local"
    gallery_config_filename = SysConfig.galleriesDir + "/" + @short_name + "/config.yaml"
      p gallery_config_filename
      return  load(gallery_config_filename)
  end
end

def EngineGallery.load(gallery_file_name)

         if File.exists?(gallery_file_name) == false
           puts("No such configuration:" + gallery_file_name )
           return nil
         end 
         
       gallery_yaml_file = File.open(gallery_file_name) 
       enginegallery = YAML::load( gallery_yaml_file)
      enginegallery
end
     
  def EngineGallery.list_local       
    @galleries = Array.new()
    gallery_dirs = Dir.entries(SysConfig.galleriesDir)
#Fixme should only match yaml files also catch exceptions on bad reads of yaml or file io
    
    gallery_dirs.each do |gallery_dir |
          gallery_file_name = SysConfig.galleriesDir + "/" + gallery_dir + "/gallery.yaml"
          
            if File.exists?(gallery_file_name)            
              gallery = EngineGallery.load(gallery_file_name)
           #   puts gallery_file_name
            #  p gallery
              @galleries.push(gallery)
            end
        end
    return @galleries
    
  end   
  
  
  
def save
         serialized_object = YAML::dump(self)  
         save_serialized(serialized_object)
end
       
def   save_serialized(serialized_object)

        gallery_dir=SysConfig.galleriesDir + "/" + @short_name
             if File.directory?(gallery_dir) ==false
               Dir.mkdir(gallery_dir)
             end
       gallery_config_filename= galleryDir + "/gallery.yaml"            
       gallery_config_file = File.new(gallery_config_file,File::CREAT|File::TRUNC|File::RDWR, 0644)
       gallery_config_file.puts(serialized_object)
       gallery_config_file.close
end


      

  
  def listBluePrints
    blueprints_uri =URI('http://220.233.20.158:3001/json_published_softwares') 
        
      Net::HTTP.start(blueprints_uri.host, blueprints_uri.port) do |http|
        blueprints_request = Net::HTTP::Get.new blueprints_uri
    
        blueprints_response = http.request blueprints_request # Net::HTTPResponse object
            if blueprints_response.code.to_i >= 200 && blueprints_response.code.to_i < 400 
              return blueprints_from_jsonstr(blueprints_response.body) 
            else
              return nil #FIXME should put error mesg somewhere
            end    
       end
  end
  
  def blueprints_from_jsonstr blueprints_json_str
    json = JSON.parse(blueprints_json_str)
    p json
     return json
   end
  
   def getBluePrint id
    
    #json = get blueprints_url + "/" + id
  end
  
  def filter_blueprints types
  end
  
  
  def get_blueprint(blueprint_id)
    blueprint_uri =URI('http://220.233.20.158:3001/json_published_softwares/' + blueprint_id ) 
           p blueprint_uri
         Net::HTTP.start(blueprint_uri.host, blueprint_uri.port) do |http|
           blueprint_request = Net::HTTP::Get.new blueprint_uri
       
           blueprint_response = http.request blueprint_request # Net::HTTPResponse object
               if blueprint_response.code.to_i >= 200 && blueprint_response.code.to_i < 400 
                 return blueprint_from_jsonstr(blueprint_response.body) 
               else
                 return nil #FIXME should put error mesg somewhere
               end    
          end
  end
protected


  
end